require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user1) { create(:user) }
  let!(:label1) { create(:label, user: user1) }
  let!(:label2) { create(:second_label, user: user1) }
  let!(:task1) {create(:task, title: 'task_t_1', content: 'task_c_1', user: user1)}
  let!(:task2) {create(:second_task, title: 'task_t_2', content: 'task_c_2', user: user1)}

  before do
    visit new_session_path
    fill_in 'メールアドレス', with: "test1@example.com"
    fill_in 'パスワード', with: "123456"
    click_button 'ログインする'
  end

  describe '新規作成機能' do
    context 'ラベルを新規作成した場合' do
      it '作成したラベルが表示される' do
        visit new_label_path
        fill_in 'ラベル', with: 'test_label'
        click_button '登録する'
        expect(page).to have_content 'test_label'
      end
    end
  end

  describe 'ラベル付け機能' do
    before { visit tasks_path }
    context 'タスクを新規作成した場合' do
      it '複数のラベルをつけることができる' do
        visit new_task_path
        fill_in 'タイトル', with: '新規タイトル'
        fill_in 'タスク詳細', with: '新規コンテンツ'
        fill_in '終了期限', with: "#{(DateTime.current + 1.days).strftime("%Y/%m/%d%T%H:%M")}"
        select '未着手', from: 'ステータス'
        select '高', from: '優先度'
        check "task_label_ids_#{label1.id}"
        check "task_label_ids_#{label2.id}"
        click_button '登録する'
        expect(page).to have_content '新規タイトル'
        expect(page).to have_content '新規コンテンツ'
        expect(page).to have_content "#{(DateTime.current + 1.days).strftime("%Y/%m/%d %H:%M")}"
        expect(page).to have_content '未着手'
        expect(page).to have_content '高'
        expect(page).to have_content 'label_1'
        expect(page).to have_content 'label_2'
      end
    end
    context 'ラベルがタスクに紐づいている場合' do
      it '詳細画面で紐づいているラベルが表示される' do
        create(:labeling, task: task1, label: label1)
        visit task_path(task1)
        expect(page).to have_content 'label_1'
        expect(page).to_not have_content 'label_2'
      end
    end
  end

  describe '検索機能' do
    before do
      visit tasks_path
      create(:labeling, task: task1, label: label1)
      create(:labeling, task: task1, label: label2)
      create(:labeling, task: task2, label: label1)
    end
    context 'ラベル検索をした場合' do
      it "ラベルが紐づいているタスクが絞り込まれる" do
        select 'label_2', from: 'ラベル'
        click_button '検索'
        expect(page).to have_content 'task_t_1'
        expect(page).to_not have_content 'task_t_2'
      end
    end
  end
end
