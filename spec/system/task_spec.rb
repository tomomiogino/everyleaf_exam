require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:task1) {create(:task, title: 'task_t_1', content: 'task_c_1', deadline: "#{DateTime.current + 1.days}")}
  let!(:task2) {create(:second_task, title: 'task_t_2', content: 'task_c_2', deadline: "#{DateTime.current + 2.days}")}

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'タイトル', with: '新規タイトル'
        fill_in 'タスク詳細', with: '新規コンテンツ'
        fill_in '終了期限', with: "#{(DateTime.current + 1.days).strftime("%Y/%m/%d%T%H:%M")}"
        select '未着手', from: 'ステータス'
        select '高', from: '優先度'
        click_button '登録する'
        expect(page).to have_content '新規タイトル'
        expect(page).to have_content '新規コンテンツ'
        expect(page).to have_content "#{(DateTime.current + 1.days).strftime("%Y/%m/%d %H:%M")}"
        expect(page).to have_content '未着手'
        expect(page).to have_content '高'
      end
    end
  end

  describe '一覧表示機能' do
    before { visit tasks_path }
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

  describe '並び替え機能' do
    before { visit tasks_path }
    context '終了期限でソートするというリンクを押すと' do
      it '終了期限の降順に並び替えられたタスク一覧が表示される' do
        click_link '終了期限でソートする'
        sleep(1)
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'task_t_2'
        expect(task_list[1]).to have_content 'task_t_1'
      end
    end
    context '優先度でソートするというリンクを押すと' do
      it '優先度の高い順に並び替えられたタスク一覧が表示される' do
        click_link '優先度でソートする'
        sleep(1)
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'task_t_1'
        expect(task_list[1]).to have_content 'task_t_2'
      end
    end
  end

  describe '検索機能' do
    before do
      create(:task, title: "サンプルa", status: 0)
      create(:second_task, title: "sample", status: 1)
      create(:task, title: "サンプルb", status: 1)
      visit tasks_path
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        fill_in 'タイトル', with: 'サンプル'
        click_button '検索'
        expect(page).to have_content 'サンプルa'
        expect(page).to have_content 'サンプルb'
        expect(page).to_not have_content 'sample'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        select '着手中', from: 'ステータス'
        click_button '検索'
        expect(page).to have_content 'sample'
        expect(page).to have_content 'サンプルb'
        expect(page).to_not have_content 'サンプルa'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in 'タイトル', with: 'サンプル'
        select '着手中', from: 'ステータス'
        click_button '検索'
        expect(page).to have_content 'サンプルb'
        expect(page).to_not have_content 'サンプルa'
        expect(page).to_not have_content 'sample'
      end
    end
  end
end
