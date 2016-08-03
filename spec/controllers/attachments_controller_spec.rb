require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE#destroy' do
    context 'Authenticated user' do
      sign_in_user
      context 'is the author of a question' do 
        let!(:question){ create :question, user: @user }
        let!(:attachment){ create(:attachment, attachable: question) }
        
        it 'deletes attachment' do                 
          expect{ delete :destroy, id: attachment, format: :js }.to change(question.attachments, :count).by -1 
        end

        it 'redirects to view index' do
          delete :destroy, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'is the author of an answer' do 
        let!(:question){ create :question }
        let!(:answer){ create :answer, question: question, user: @user }
        let!(:attachment){ create(:attachment, attachable: answer) }
        
        it 'deletes attachment' do                 
          expect{ delete :destroy, id: attachment, format: :js }.to change(answer.attachments, :count).by -1 
        end

        it 'redirects to view index' do
          delete :destroy, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'is not the owner of a question' do      
        let!(:question_another){ create :question }
        let!(:attachment_another){ create(:attachment, attachable: question_another) }      
        
        it 'fails to delete an antachment' do        
          expect{ delete :destroy, id: attachment_another, format: :js }.to_not change(Attachment, :count)
        end

        it 'redirect to view index' do
          delete :destroy, id: attachment_another, format: :js
          expect(response).to redirect_to questions_path
        end
      end
    end 
  end
  
  context 'Non authenticated user fails to' do
    let!(:question){ create :question}

    context 'question attachments' do
      let!(:attachment){ create(:attachment, attachable: question) }

      it 'fails to delete' do        
        expect{ delete :destroy, id: attachment, format: :js }.to_not change(Attachment, :count)
      end
    end

    context 'answer attachments' do
      let!(:answer){ create :answer, question: question }
      let!(:attachment){ create(:attachment, attachable: answer) }

      it 'fails to delete' do        
        expect{ delete :destroy, id: attachment, format: :js }.to_not change(Attachment, :count)
      end
    end
  end 

end