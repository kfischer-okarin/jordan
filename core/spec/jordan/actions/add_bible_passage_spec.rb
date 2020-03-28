# frozen_string_literal: true

module Jordan
  module Actions
    RSpec.describe AddBiblePassage do
      subject(:execute) { action.execute(user_id: user_id, video_id: video_id, position: position, passage: passage) }

      let(:action) { described_class.new(videos: videos, annotations: annotations, viewers: viewers) }

      let(:user_id) { :user_id }
      let(:video_id) { :video }
      let(:passage) { :bible_passage }

      let(:created_annotation) { :created_annotation }

      let(:videos) { spy('videos', get: video) }
      let(:annotations) { spy('annotations', create: created_annotation) }
      let(:viewers) { spy('viewers') }

      shared_examples 'Common' do
        describe 'Errors' do
          it 'raises NotFound if video does not exist' do
            allow(videos).to receive(:get).and_raise Exceptions::NotFound

            expect { execute }.to raise_error Exceptions::NotFound
          end

          context 'when specifying a negative position' do
            let(:position) { -1 }

            it 'raises InvalidParameters' do
              expect { subject }.to raise_error Exceptions::InvalidParameters
            end
          end

          context 'when the video is not owned by the user' do
            let(:video) { build(:video, owner: 'other_user') }

            it 'raises Forbidden' do
              expect { subject }.to raise_error Exceptions::Forbidden
            end
          end
        end

        it 'creates an Annotation' do
          execute

          expect(annotations).to have_received(:create).with(video_id: video_id, position: position, type: :bible_verse, passage: passage)
        end

        it 'notifies the viewers' do
          execute

          expect(viewers).to have_received(:notify).with(created_annotation)
        end

        it 'returns the created annotation' do
          expect(execute).to eq created_annotation
        end
      end

      context 'With a normal video' do
        let(:video) { build(:video, owner: user_id) }
        let(:position) { 10 }

        include_examples 'Common'

        describe 'Errors' do
          context 'when specifying a position outside of the video' do
            let(:position) { video.duration + 1 }

            it 'raises InvalidParameters' do
              expect { subject }.to raise_error Exceptions::Unprocessable
            end
          end
        end
      end

      context 'If the video is a livestream' do
        let(:video) { build(:livestream, owner: user_id, start: stream_start) }
        let(:stream_start) { Time.local(2020, 3, 29, 10, 0, 0) }
        let(:now) { Time.local(2020, 3, 29, 10, 15, 0) }
        let(:position) { 10 }

        around do |example|
          Timecop.freeze(now) do
            example.run
          end
        end

        include_examples 'Common'

        context 'When trying to'
      end
    end
  end
end
