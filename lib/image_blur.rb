require 'image_blur/version'

module ImageBlur
  class Processor
    attr_reader :image, :blurred_image

    def initialize(image)
      @image = image
    end

    def blur
      blurred_image = image.collect { |x_row| x_row.dup }

      image.each_with_index do |row, y_coordinate|
        row.each_with_index do |pixel, x_coordinate|
          if must_blur?(pixel)
            blur_positions = calculate_blur_positions(x_coordinate, y_coordinate)
            blur_positions.each { |position| blur_in_coordinate(blurred_image, position.first, position.last) }
          end
        end
      end

      @blurred_image = blurred_image
    end

    def calculate_blur_positions(x, y)
      x_length, y_length = image_size

      coordinates = [[x-1, y], [x+1, y], [x, y+1], [x, y-1]]

      coordinates.reject do |coordinate|
        blur_x = coordinate.first
        blur_y = coordinate.last
        blur_x < 0 or blur_y < 0 or blur_x == x_length or blur_y == y_length
      end
    end

    private

    def image_size
      if image.empty?
        return 0, 0
      else
        return image.size, image.first.size
      end
    end

    def blur_in_coordinate(image, coordinate_x, coordinate_y)
      image[coordinate_y][coordinate_x] = 1
    end

    def must_blur?(current_pixel)
      current_pixel == 1
    end
  end
end
