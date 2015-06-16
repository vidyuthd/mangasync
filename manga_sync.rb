require 'open-uri'
require 'json'
require './sources'

class MangaSync

  def method(series_name, start_chapter, end_chapter, source)
    local_start_chapter = start_chapter.clone

    if local_start_chapter.to_i > end_chapter.to_i
      return
    end

    page=1
    json = JSON.parse($mangasource)
    sourcejson = json["source-details"][source]
    series_dir = File.join(File.absolute_path(''), (series_name.to_s))
    chapter_dir = File.join(File.absolute_path(''), (series_name.to_s), (local_start_chapter.to_s))
    series_name = preparenamebasedonsource(sourcejson, series_name)

    if (!Dir.exist?(series_dir))
      Dir.mkdir(series_dir, 0755)
    end
    if (!Dir.exist?(chapter_dir))
      Dir.mkdir(chapter_dir, 0755)
    end
    while File.exist?(File.join(chapter_dir.to_s, page.to_s+".png")) && !File.zero?(File.join(chapter_dir.to_s,
                                                                                              page.to_s+".png"))
      page=page+1
    end

    page_url = sourcejson["page-url"]
    volume = determinevolume(sourcejson, series_name, local_start_chapter)
    local_start_chapter = source == 'mangafox' ? local_start_chapter.rjust(3, '0') : local_start_chapter
    primary_regex = Regexp.new(sourcejson["image-matching-regex-string"])
    img_format = sourcejson["image-pattern"]
    img_pattern = img_format

    if img_format.split(",").length > 0
      img_pattern = "["
      for item in img_format.split(",")
        img_pattern = img_pattern+item+"|"
      end
      img_pattern += "]"
    end

    secondary_regex= Regexp.new("http.*"+img_pattern)

    while open(page_url.gsub('<series_name>', series_name).gsub('<chapter_no>', local_start_chapter).gsub('<volume>', volume).
                   gsub('<page_no>', page.to_s)) { |f|
      p "hitting url:  "+page_url.gsub('<series_name>', series_name).gsub('<chapter_no>', local_start_chapter).
            gsub('<volume>', volume).gsub('<page_no>', page.to_s)
      found = false
      f.each_line { |line|
        if (url = line.to_s.match(primary_regex).to_s.match(secondary_regex)) && !found
          file_to_write = File.join(chapter_dir.to_s, page.to_s+".png")
          File.open(file_to_write, 'wb') do |fo|
            fo.write open((url.to_s),
                          "User-Agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36",
                          "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                     ).read
          end
          page = page+1
          found = true
        end
      }
    }
    end
  rescue OpenURI::HTTPError
    puts $!, $@
  end

  def getThread(start_chapter, end_chapter, series_name, source)
    Thread.new(series_name, start_chapter, end_chapter, source) { method(series_name, start_chapter, end_chapter, source) }
  end

  def validatesource(source)
    json = JSON.parse($mangasource)
    sourcematch = false
    for item in json["sources"]
      if item==source
        sourcematch = true
      end
    end

    return sourcematch
  end

  def preparenamebasedonsource(sourcejson, series_name)
    arr = series_name.split(" ")
    if arr.length > 0
      multiword_seperator = sourcejson["multiword-seperator"]
      if sourcejson["capitalize-series-name"] != nil && sourcejson["capitalize-series-name"]=="true"
        arr.map! { |item|
          item = item.capitalize
        }
      end
      series_name = arr.join(multiword_seperator)
    end
  else
    return series_name
  end

  def determinevolume(sourcejson, series_name, chapter_no)
    volume = ""

    if chapter_no.to_i < 100
      chapter_no = chapter_no.rjust(3, '0')
    end

    str = '"http.*c'+chapter_no+'\/.*html"'
    r = Regexp.new(str)
    if sourcejson["volume-determine-url"] != nil
      url = sourcejson["volume-determine-url"].gsub('<series_name>', series_name)
      open(url) { |f|
        f.each_line { |line|
          if line.to_s.match(r)
            volume = (line.to_s.match(r).to_a)[0].match(/v\d*/).to_s
            break
          end
        }
      }
    end
    return volume
  end

  def connect_to_method
    printf "input series name : "
    series_name = gets().chomp().downcase

    printf "input start chapter no : "
    start_chapter = gets().chomp.downcase

    if start_chapter == ""
      puts "Oops You need to give a start chapter or otherwise nothing can be done"
      return
    end

    printf "input end chapter no(if you need only one chapter, the leave this blank by pressing enter or give same
    value as start chapter) : "
    end_chapter = gets().chomp.downcase
    printf "input manga source by number (this can be mangapanda,mangareader,mangafox,mangajoy,mangasee,mangatown -leave this blank
    if you are not sure by pressing enter button): "
    source = gets().chomp.downcase
    source = source!= "" ? source : "mangareader"

    if !validatesource(source)
      puts "Oops looks like the source you have given doesn't match with the ones currently present, please select
      from the provided ones "
      return
    end

    start_time = Time.now

    if end_chapter == ""
      end_chapter = start_chapter
    end

    start_chapter=(start_chapter.to_i-1).to_s

    threads = []
    while start_chapter.to_i <= end_chapter.to_i
      for i in 1..5
        threads << getThread(start_chapter.next!, end_chapter, series_name, source)
        sleep(0.005)
      end
    end
    for thread in threads
      thread.join
    end
    threads.clear

    end_time= Time.now
    printf("Total time taken(in seconds) is "+(end_time-start_time).to_s)
  end
end

mangaObj = MangaSync::new
mangaObj.connect_to_method
