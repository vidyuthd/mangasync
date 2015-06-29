# Mangasync

A simple ruby script to download your favorite manga chapters to your
machine so that you can read them in your free time.

## Instructions on usage
1. ```git clone https://github.com/vidyuthd/mangasync```
2. ``` cd mangasync ```
3. ``` ruby manga_sync.rb ```

### Sample Output
>       input series name : one-piece
>       input start chapter no : 791
>       input end chapter no(if you need only one chapter, the leave this blank by pressing enter or give same
            value as start chapter) :
        input manga source by number (this can be mangapanda,mangareader,mangafox,mangajoy,mangasee,mangatown,readmanga -leave this blank
            if you are not sure by pressing enter button):
       "hitting url:  http://mangareader.net/one-piece/791/1"
       "hitting url:  http://mangareader.net/one-piece/791/2"
       "hitting url:  http://mangareader.net/one-piece/791/3"
       "hitting url:  http://mangareader.net/one-piece/791/4"
       "hitting url:  http://mangareader.net/one-piece/791/5"
       "hitting url:  http://mangareader.net/one-piece/791/6"
       "hitting url:  http://mangareader.net/one-piece/791/7"
       "hitting url:  http://mangareader.net/one-piece/791/8"
       "hitting url:  http://mangareader.net/one-piece/791/9"
       "hitting url:  http://mangareader.net/one-piece/791/10"
       "hitting url:  http://mangareader.net/one-piece/791/11"
       "hitting url:  http://mangareader.net/one-piece/791/12"
       "hitting url:  http://mangareader.net/one-piece/791/13"
       "hitting url:  http://mangareader.net/one-piece/791/14"
       "hitting url:  http://mangareader.net/one-piece/791/15"
       "hitting url:  http://mangareader.net/one-piece/791/16"
       404 Not Found
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:358:in `open_http'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:736:in `buffer_open'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:211:in `block in open_loop'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:209:in `catch'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:209:in `open_loop'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:150:in `open_uri'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:716:in `open'
       C:/Ruby22/lib/ruby/2.2.0/open-uri.rb:34:in `open'
       manga_sync_v2.rb:46:in `method'
       manga_sync_v2.rb:71:in `block in getThread'
       Total time taken(in seconds) is 38.583858
    
## Prerequisites 
       
1. Have ruby installed on your machine. 
2. If not [install ruby](https://www.ruby-lang.org/en/documentation/installation/)