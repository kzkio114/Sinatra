require 'sinatra'
require 'erb'

class App < Sinatra::Base
  @@profile = {
    "ニックネーム" => "kzkio(かずちゃん)",
    "年齢" => "31歳",
    "趣味" => "爬虫類飼育など",
    "出身地" => "埼玉県"
  }

  @@additional_questions_and_answers = {
    "ニックネーム" => {
      "question" => "なぜニックネームをkzkio(かずちゃん)にしたか聞きたいですか？(はい/いいえ)",
      "answer" => "自分の名前が、よくある名前なので下の名前+苗字をローマ字で書いて1文字抜いて誰も被らないようにしてみました。読みづらいのでkzて呼んでもいいですよ!・・・それも、読みづらいので交流会で新しいニックネームを授かりました！！かずちゃんです！！"
    },
    "年齢" => {
      "question" => "具体的な生年月日も知りたいですか？(はい/いいえ)",
      "answer" => "1992年1月14日生まれです。"
    },
    "趣味" => {
      "question" => "どんな爬虫類を飼っているか？聞きたいですか？(はい/いいえ)",
      "answer" => "アミメミズベトカゲとアストロジャイアントダイビングスキンクなどを飼っています！"
    },
    "出身地" => {
      "question" => "埼玉県の何処の辺に住んでるか知りたいですか？(はい/いいえ)",
      "answer" => "お茶の有名な所です！。"
    }
  }

  @@reptile_details = {
    "アミメ" => {
      "description" => "アミメミズベトカゲは、マダカスカルに住んでいるトカゲで水の流れ余りない水辺に住んでいます。",
      "image" => "https://drive.google.com/uc?id=11rLinPaIqJOFBbil2fXz84cJ9cXxRc3K"
    },
    "アストロ" => {
      "description" => "アストロジャイアントダイビングスキンクは、マダガスカルに住んでいて川辺などに住んでいます。甲殻類を食べます",
      "image" => "https://drive.google.com/uc?id=123o--vipqbaB_-bvB_zNzTOQ29RNt9O6"
    }
  }

  get '/' do
    erb :index, locals: { profile: @@profile }
  end

  get '/details/:item' do
    item = params[:item]
    if @@additional_questions_and_answers.key?(item)
      question = @@additional_questions_and_answers[item]["question"]
      erb :details, locals: { item: item, question: question }
    else
      redirect '/'
    end
  end

  post '/details/:item' do
    item = params[:item]
    user_answer = params[:user_answer]

    if user_answer == 'はい' && @@additional_questions_and_answers.key?(item)
      if item == '趣味'
        erb :reptiles, locals: { reptile_details: @@reptile_details }
      else
        answer = @@additional_questions_and_answers[item]["answer"]
        erb :answer, locals: { item: item, answer: answer }
      end
    else
      redirect '/'
    end
  end

  get '/reptile/:name' do
    name = params[:name]
    if @@reptile_details.key?(name)
      description = @@reptile_details[name]["description"]
      image = @@reptile_details[name]["image"]
      erb :reptile, locals: { name: name, description: description, image: image }
    else
      redirect '/details/趣味'
    end
  end

  run! if app_file == $0
end

__END__

@@index
<h1>kzkio(かずちゃん)のプロフィール</h1>
<ul>
  <% profile.each do |key, value| %>
    <li><a href="/details/<%= key %>"><%= key %>: <%= value %></a></li>
  <% end %>
</ul>

@@details
<h1><%= item %>について</h1>
<form method="post" action="/details/<%= item %>">
  <p><%= question %></p>
  <input type="radio" id="yes" name="user_answer" value="はい">
  <label for="yes">はい</label><br>
  <input type="radio" id="no" name="user_answer" value="いいえ">
  <label for="no">いいえ</label><br>
  <input type="submit" value="送信">
</form>
<br>
<a href="/">戻る</a>

@@reptiles
<h1>どちらについて知りたいですか？</h1>
<ul>
  <% reptile_details.keys.each do |reptile| %>
    <li><a href="/reptile/<%= reptile %>"><%= reptile %></a></li>
  <% end %>
</ul>
<br>
<a href="/">戻る</a>

@@answer
<h1><%= item %>についての追加情報</h1>
<p><%= answer %></p>
<br>
<a href="/">戻る</a>

@@reptile
<h1><%= name %>について</h1>
<p><%= description %></p>
<p>画像はこちら: <a href="<%= image %>" target="_blank">リンク</a></p>
<br>
<a href="/details/趣味">戻る</a>
