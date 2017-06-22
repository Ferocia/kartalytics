require 'spec_helper'

describe Kartalytics::ScoreBlock do
  let(:score_block) { described_class.new(image) }

  describe '#to_i' do
    subject { score_block.to_i }

    context 'standard block' do
      let(:image) { fixture 'images/score_block1.jpg' }

      it 'returns correct value' do
        pending
        is_expected.to eql 47
      end
    end

    context 'yellow block' do
      let(:image) { fixture 'images/score_block2.jpg' }

      it 'returns correct value' do
        pending
        is_expected.to eql 19
      end
    end

    context 'blue block' do
      let(:image) { fixture 'images/score_block3.jpg' }

      it 'returns correct value' do
        pending
        is_expected.to eql 10
      end
    end

    context 'red block' do
      let(:image) { fixture 'images/score_block4.jpg' }

      it 'returns correct value' do
        pending
        is_expected.to eql 19
      end
    end

    context 'empty block' do
      let(:image) { fixture 'images/score_block4.jpg' }

      it 'returns correct value' do
        is_expected.to eql nil
      end
    end
  end
end
