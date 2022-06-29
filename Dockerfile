# テキストのバージョンであるRuby3.0.1に揃える
FROM ruby:3.0.1
 
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
 
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN mkdir /blog_app
WORKDIR /blog_app
COPY Gemfile /blog_app/Gemfile
COPY Gemfile.lock /blog_app/Gemfile.lock
RUN bundle install
COPY . /blog_app
 
# コンテナ起動時に毎回実行する
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
 
# rails s　実行.
CMD ["rails", "server", "-b", "0.0.0.0"]