require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:task1) {create(:task, title: 'task_t_1', content: 'task_c_1')}
  let!(:task2) {create(:second_task, title: 'task_t_2', content: 'task_c_2')}

  before do
    visit tasks_path
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'タイトル', with: '新規タイトル'
        fill_in 'タスク詳細', with: '新規コンテンツ'
        click_button '登録する'
        expect(page).to have_content '新規タイトル'
        expect(page).to have_content '新規コンテンツ'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'task_t_1'
        expect(page).to have_content 'task_t_2'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'task_t_2'
        expect(task_list[1]).to have_content 'task_t_1'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit task_path(task1)
        expect(page).to have_content 'task_t_1'
        expect(page).to have_content 'task_c_1'
      end
    end
  end
end
