summary     'creates a new blog post'
description <<desc
This command creates a new blog post under content/blog/{year}/{month}/example.html. 
You can additionally pass in the description, the tags and the creation date.
desc
usage     'new-blog name [options]'

option :b, :abstract,  'description for this blog post (ex. "This is a description")', :argument => :optional
option :t, :tags,         'tags for this blog post (ex. "these,are,tags")', :argument => :optional
option :d, :created_at,   'creation date for this blog post (ex. "2013-01-03 10:24")', :argument => :optional
option :c, :category,   'category', :argument => :optional

flag   :h, :help,  'show help for this command' do |value, cmd|
  puts cmd.help
  exit 0
end

run do |opts, args, cmd|
  # requirements
  require 'stringex'
  require 'highline'

  # load up HighLine
  line = HighLine.new

  # get the name and description parameter or the default
  name = args[0] || "new-blog-post"
  description = opts[:abstract] || "This is the description"

  category = opts[:category] || "Other"

  # convert the tags string to and array of trimmed strings
  tags = opts[:tags].split(",").map(&:strip) rescue ['Unkonw']

  # convert the created_at parameter to a Time object or use now
  timestamp = DateTime.parse(opts[:created_at]).to_time rescue Time.now

  # make the directory for the new blog post
  dir = "content/posts"
  
  FileUtils.mkdir_p dir

  # make the full file name
  yExten = 'yaml'
  oExten = 'org'
  filename = "#{dir}/#{timestamp.strftime('%Y-%m-%d')}-#{name.to_url}"
  yFilename = "#{filename}.#{yExten}"
  oFilename = "#{filename}.#{oExten}"

  # check if the file exists, and ask the user what to do in that case
  if File.exist?(yFilename) && line.ask("#{yFilename} already exists. Want to overwrite? (y/n)", ['y','n']) == 'n'

    # user pressed 'n', abort!
    puts "Blog post creation aborted!"
    exit 1
  end

  # write the scaffolding
  puts "Creating new post: #{yFilename}"
  open(yFilename, 'w') do |post|
    post.puts "---"
    post.puts "title: #{name}"
    post.puts "created_at: #{timestamp.strftime('%Y-%m-%d %H:%M:%S')}"
    post.puts "kind: article"
    post.puts "abstract:\n  #{description}"
    post.puts "category: #{category}"
    post.puts "tags:\n"
    tags.each do |tag|
        post.puts " - #{tag}\n"
    end
  end

  # write org file
  puts "Creating new post: #{oFilename}"
  open(oFilename, 'w') do |post|
    post.puts "#+TITLE: #{name}"
  end
end
