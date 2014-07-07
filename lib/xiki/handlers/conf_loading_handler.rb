module Xiki
  class ConfLoadingHandler
    def self.handle options

      # Always try loading options[:conf] (from /index.conf or ~/menu/conf/foo.conf...

      self.load_conf options   # should we avoid loading conf when we're the conf? - probably doesn't matter, since conf/index.conf doesn't exist
    end

    # Populates options[:conf] based on /index.conf or ~/menu/conf/foo.conf.
    def self.load_conf options
      conf = options[:sources][0].find{|o| o =~ /\.conf$/}  # Grab just the root index.conf
      conf = "#{File.dirname(options[:menufied])}/#{conf}"

      conf = File.file?(conf) ? File.read(conf) : nil

      conf = conf ? "#{conf.strip}\n" : ""

      user_conf = Xiki.menu_path_dirs[0]

      user_conf = "~/menu/conf/#{options[:name]}.conf"
      user_conf = File.expand_path user_conf
      user_conf = File.file?(user_conf) ? File.read(user_conf) : ""

      # Pass conf as Xi string, so menus can wrap Xi instance around it or just call Tree.children directly
      conf = "#{user_conf.strip}\n#{conf}" if user_conf   # Put user conf at top, so it'll be found first by .children

      options[:conf] = conf if conf.any?
    end

    def self.parse(text)
      conf = Hash.new
      text.each_line do |line|
        if line[0] != '>' then
          if line[0] == '-' then line[0] = ' ' end
          line.lstrip!
          param = line.split ':'
          unless param.empty? then
            conf[param[0].strip] = param[1].strip
          end
        end
      end
      conf
    end

  end
end
