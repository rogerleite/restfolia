
# Run this sample from root project:
# $ ruby samples/cookies_options.rb

require "rubygems"
$LOAD_PATH << "lib"
require "restfolia"

SERVICE_URL = "http://localhost:9292/recursos/busca"

sample_cookie = "PREF=ID=988f14fa5edd3243:TM=1335470032:LM=1335470032:S=KVBslNbyz6bG0DqU; expires=Sat, 26-Apr-2014 19:53:52 GMT; path=/; domain=.google.com, NID=59=peUyZQuLWQ_0gELr1yDf0FT4ZlT7ZdITNrO5OhkEnAvp_8MZ4TT6pHq7_q_Su-puTw7vGml_Ok6du8fLreGHzfpMs4Qh1v-qBCFYGuCNbzpwN670x5MFbGKy0KUXA3WP; expires=Fri, 26-Oct-2012 19:53:52 GMT; path=/; domain=.google.com; HttpOnly"

# accessing cookies attribute
entry_point = Restfolia.at(SERVICE_URL)
entry_point.cookies = sample_cookie
resource = entry_point.get

# adding in a fancy way
resource = Restfolia.at(SERVICE_URL).
                  set_cookies(sample_cookie).get

puts "Done!"

