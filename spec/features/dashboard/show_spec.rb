require 'rails_helper'
require 'csv'

RSpec.describe 'dashboard' do
  describe 'as a user' do
    describe 'when I visit the dashboard' do
      before :each do
        @user = create(:user)
        emotions_list = CSV.parse(File.read('spec/emotions_list/Emotions.csv'), headers:true)
        @emotions = emotions_list.map {|emotion| Emotion.new(emotion)} 
        @chosen_emotion = @emotions.first
        allow(DatabaseFacade).to receive(:emotions).and_return(@emotions)
        allow(DatabaseFacade).to receive(:emotion).with(@chosen_emotion.word).and_return(@chosen_emotion)
        allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
        visit dashboard_path
      end
      it 'has a welcome message with users name' do
        expect(page).to have_content("Welcome, #{@user.name}")
      end

      it 'has a drop down menu with a list of all emotions' do
        # save_and_open_page
        within '#emotion_form' do
          @emotions.each do |emotion|
            page.has_select? emotion.word
          end
        end
      end

      describe 'when I submit an emotion' do
        before :each do
          within '#emotion_form' do
            select @chosen_emotion.word
            click_button 'submit'
          end
        end
        it 'I am returned to the dashboard page' do
          expect(current_path).to eq(dashboard_path)
        end

        it 'I see the definition of the emotion' do
          within '#emotion_def' do
            expect(page).to have_content(@chosen_emotion.definition)
          end
        end

        it 'I see a text box appear' do
          within '#emotion_form' do
            expect(page).to have_field(:description, type: 'textarea')
          end
        end

        it 'I see a post status radio button with yes and no' do
          within '#emotion_form' do
            expect(page).to have_field('Yes')
            expect(page).to have_field('No')
          end
        end

        it 'post status public question is no by default' do
          within '#emotion_form' do
            expect(page).to have_checked_field('No')
          end
        end

        it 'I see a link to change emotion choice' do
          expect(page).to have_link('Change emotion choice')
        end

        it 'clicking link to change emotion choice takes me back to dashboard page with dropdown' do
          click_link 'Change emotion choice'
          expect(current_path).to eq(dashboard_path)
          within '#emotion_form' do
            @emotions.each do |emotion|
              page.has_select? emotion.word
            end
          end
        end
      end

      describe 'when I submit an emotion and description' do
        before :each do
          @last_post = build(:post)

          allow(DatabaseFacade).to receive(:new_post).and_return(201)
          allow(DatabaseFacade).to receive(:last_post).and_return(@last_post)
          allow(DatabaseFacade).to receive(:emotion_by_id).and_return(@chosen_emotion.word)

          within '#emotion_form' do
            select @chosen_emotion.word
            click_button 'submit'
          end
          within '#emotion_form' do
            fill_in :description, with: @last_post.description
            click_button 'submit'
          end
        end

        it 'returns me to the dashboard' do
          expect(current_path).to eq(dashboard_path)
        end

        it 'does not have an emotion form' do
          expect(page).to_not have_css('#emotion_form')
        end

        it 'instead shows the most recent post' do
          within '#recent_post' do
            expect(page).to have_content(@last_post.description)
            expect(page).to have_content("I am feeling #{@chosen_emotion.word}")
            expect(page).to have_content(@last_post.tone)
            expect(page).to have_content(@last_post.post_status)
          end
        end
      end
    end
  end
end