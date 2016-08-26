require 'spec_helper'

describe ImageBlur::Processor do
  def create_base_image(x_length, y_length)
    image = []
    y_length.times do
      image << Array.new(x_length, 0)
    end
    image
  end

  describe '#calculate_blur_positions' do
    let(:image) { create_base_image(5, 5) }

    it 'rejects out of bounds positions' do
      processor = described_class.new image
      positions = processor.calculate_blur_positions(0, 4)
      expect(positions).to match_array([[0, 3], [1, 4]])
    end
  end

  describe '#blur' do
    context 'receives an image that hasnt to be blurred' do
      let(:image) { create_base_image(5, 5) }
      it 'returns the same image' do
        processor = described_class.new image
        expect(processor.blur).to match_array(image)
      end
    end

    it 'blurs the surrounding positions in the middle' do
      input = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
      ]

      expected_output_image = [
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 1, 1, 1, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0]
      ]
      processor = described_class.new input
      expect(processor.blur).to match_array(expected_output_image)
    end

    it 'blurs the corner' do
      input = [
          [0, 0, 0, 0, 1],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
      ]

      expected_output_image = [
          [0, 0, 0, 1, 1],
          [0, 0, 0, 0, 1],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
      ]

      processor = described_class.new input
      blurred_image = processor.blur
      expect(processor.blur).to match_array(expected_output_image)
    end
  end
end
