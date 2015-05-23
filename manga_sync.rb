require 'open-uri'

HTTP_URL_SEPERATOR = "/"

class MangaSync
  def connect_to_method
    printf "input series name : "
    series_name = gets().chomp().downcase
    printf "input start chapter no : "
    start_chapter = gets().chomp.downcase
    page=1
    series_dir = File.join(File.absolute_path(''), (series_name.to_s))
    chapter_dir = File.join(File.absolute_path(''), (series_name.to_s), (start_chapter.to_s))
    if (!Dir.exist?(series_dir))
      Dir.mkdir(series_dir, 0755)
    end
    if (!Dir.exist?(chapter_dir))
      Dir.mkdir(chapter_dir, 0755)
    end
    while File.exist?(File.join(chapter_dir.to_s, page.to_s+".png"))
      page=page+1
    end
    while open(("http://www.mangareader.net/"+series_name+HTTP_URL_SEPERATOR+start_chapter+HTTP_URL_SEPERATOR+page.to_s)) { |f|
      p "hitting url:  "+"http://www.mangareader.net/"+series_name+HTTP_URL_SEPERATOR+start_chapter.to_s+HTTP_URL_SEPERATOR+page.to_s
      f.each_line { |line|
        if url = line.to_s.match(/"http.*jpg"/).to_s.match(/http.*jpg/)
          file_to_write = File.join(chapter_dir.to_s, page.to_s+".png")
          File.open(file_to_write, 'wb') do |fo|
            fo.write open((url.to_s),
                          "User-Agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.65 Safari/537.36",
                          "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                     ).read
          end
          page = page+1
        end
      }
    }
    end
  rescue OpenURI::HTTPError
    puts $!, $@
  end
end

mangaObj = MangaSync::new
mangaObj.connect_to_method