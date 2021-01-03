require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:second_user) }

  describe 'ユーザ登録機能' do
    context 'ユーザの新規登録をした場合' do
      it 'マイページに登録内容が表示される' do
        visit new_user_path
        fill_in '名前', with: 'test_user'
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード', with: '000000'
        fill_in 'パスワード(確認)', with: '000000'
        click_on "登録する"
        expect(page).to have_content 'test_user'
        expect(page).to have_content 'test@test.com'
      end
    end
    context 'ユーザがログインせずタスク一覧画面に飛ぼうとした場合' do
      it 'ログイン画面に遷移する' do
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'セッション機能' do
    context 'ログイン画面の入力情報がユーザーの登録情報と一致した場合' do
      it 'ログインする' do
        visit new_session_path
        fill_in 'メールアドレス', with: 'test1@example.com'
        fill_in "パスワード", with: '123456'
        click_button 'ログインする'
        expect(page).to have_content 'ログインしました！'
      end
    end
    context '一般ユーザがログインしている場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: 'test1@example.com'
        fill_in "パスワード", with: '123456'
        click_button 'ログインする'
        expect(page).to have_content 'ログインしました！'
      end
      it '自分の詳細画面に飛べる' do
        visit user_path(user1.id)
        expect(page).to have_content "#{user1.name}さんのページ"
        expect(page).to have_content "#{user1.name}"
        expect(page).to have_content "#{user1.email}"
      end
      it '他人の詳細画面に飛ぶとタスク一覧画面に遷移する' do
        visit user_path(user2.id)
        expect(current_path).to eq tasks_path
      end
      it 'ログアウトができる' do
        click_link 'ログアウト'
        expect(current_path).to eq new_session_path
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe '管理画面のテスト' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'admin@example.com'
      fill_in "パスワード", with: '000000'
      click_button 'ログインする'
      visit admin_users_path
    end
    context '管理ユーザーの場合' do
      it '管理画面にアクセスできる' do
        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'ユーザー一覧'
        expect(page).to have_content 'test1'
        expect(page).to have_content 'admin'
      end
      it 'ユーザーの新規登録ができる' do
        click_on '新規ユーザー登録'
        visit new_admin_user_path
        fill_in '名前', with: 'createduser'
        fill_in 'メールアドレス', with: 'user@user.com'
        check 'user_admin'
        fill_in 'パスワード', with: '1111111'
        fill_in 'パスワード(確認)', with: '1111111'
        click_on '登録する'
        expect(page).to have_content 'createduser'
        expect(page).to have_content 'ユーザー『createduserさん』を登録しました！'
      end
      it '他のユーザーの詳細画面にアクセスできる' do
        visit admin_user_path(user1.id)
        expect(page).to have_content "#{user1.name}さんのページ"
        expect(page).to have_content "#{user1.name}"
        expect(page).to have_content "#{user1.email}"
      end
      it '他のユーザーの編集画面からユーザを編集できる' do
        visit edit_admin_user_path(user1.id)
        fill_in '名前', with: 'hoge'
        fill_in 'メールアドレス', with: 'hoge@hoge.com'
        fill_in 'パスワード', with: 'aaaaaa'
        fill_in 'パスワード(確認)', with: 'aaaaaa'
        click_on '更新する'
        expect(page).to have_content 'hoge'
        expect(page).to_not have_content 'test1'
        expect(page).to have_content "ユーザー『hogeさん』を更新しました！"
      end
      it '他のユーザーを削除できる' do
        visit admin_user_path(user1.id)
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ユーザー『test1さん』を削除しました！'
        expect(page).to_not have_content 'test1@example.com'
      end
    end
    context '一般ユーザーの場合' do
      it '管理画面にアクセスできない' do
        visit new_session_path
        fill_in 'メールアドレス', with: 'test1@example.com'
        fill_in "パスワード", with: '123456'
        click_button 'ログインする'
        visit admin_users_path
        expect(current_path).to_not eq admin_users_path
        expect(current_path).to eq tasks_path
      end
    end
  end
end
