require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', content: '失敗テスト', deadline: "#{DateTime.current + 1.days}", status: 0)
        expect(task).not_to be_valid
      end
    end
    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(title: '失敗テスト', content: '', deadline: "#{DateTime.current + 1.days}", status: 0)
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = Task.new(title: 'テストt', content: 'テストc', deadline: "#{DateTime.current + 1.days}", status: 0)
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    let!(:user1) { create(:user) }
    let!(:task1) { create(:task, title: 'サンプルa', status: 0, user: user1) }
    let!(:task2) { create(:second_task, title: "sample", status: 1, user: user1) }
    let!(:task3) { create(:task, title: 'サンプルb', status: 1, user: user1) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(Task.search_title('サンプル')).to include(task1)
        expect(Task.search_title('サンプル')).to include(task3)
        expect(Task.search_title('サンプル')).not_to include(task2)
        expect(Task.search_title('サンプル').count).to eq 2
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status(0)).to include(task1)
        expect(Task.search_status(0)).not_to include(task2)
        expect(Task.search_status(0)).not_to include(task3)
        expect(Task.search_status(0).count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search(title: 'サンプル', status: Task.statuses.key(1))).to include(task3)
        expect(Task.search(title: 'サンプル', status: Task.statuses.key(1))).not_to include(task1)
        expect(Task.search(title: 'サンプル', status: Task.statuses.key(1))).not_to include(task2)
        expect(Task.search(title: 'サンプル', status: Task.statuses.key(1)).count).to eq 1
      end
    end
  end
end
