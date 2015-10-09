require "mini_magick"

module MiniMagick
  class Image
    def get_median_color
      color = run_command("convert", path, "-format", "%c\n", "-colors", 1, "-depth", 8, "histogram:info:")
      {
        hex: color.split[-2][0..6],
        rgb: color.split[-1][/\(.*\)/]
      }
    end

    def get_dominant_color
      txt = run_command("convert", path, "-format", "%c\n", "-colors", 256, "-depth", 8, "histogram:info:")
      color = txt.lines.sort.reverse[0]
      {
        hex: color.split[-2][0..6],
        rgb: color.split[1]
      }
    end

    def get_dominant_colors n
      colors = []
      return colors if n < 1
      txt = run_command("convert", path, "-format", "%c\n", "-colors", 256, "-depth", 8, "histogram:info:")
      txt.lines.sort.reverse[0..n-1].each do |x|
        colors << x.split[-2][0..6]
      end
      colors
    end

    def pixel_at(x, y)
      case run_command("convert","#{path}[1x1+#{x}+#{y}]", "-depth", 8, "txt:").split("\n")[1]
      when /^0,0:.*(#[\da-fA-F]{6}).*$/ then $1
      else nil
      end
    end
  end
end
