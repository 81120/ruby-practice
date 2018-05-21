require 'json'

def walk json_content, parent_key, visitor
  json_content.each do |key, value|
    if value.class == String or value.class == Integer
      visitor.call({
        :path => parent_key,
        :value => {key => value}
      })
    else value.class == Hash
      new_key = [parent_key, key].join(' ').strip
      walk value, new_key, visitor
    end
  end
end

def visitor_creator container
  lambda do |node|
    path = node.fetch :path
    value = node.fetch :value
    puts "#{path} => #{value}"
    if container.key? path
      container[path] = container[path].update value
    else
      container[path] =value
    end
  end
end

path_of_file = './style.json'
File.open path_of_file, 'r' do |file|
  content = JSON.parse file.read
  content.each do |key, value| 
    puts "#{key} => #{value}"
  end
  result = Hash.new
  visitor = visitor_creator result
  walk content, '', visitor
  puts result
end

