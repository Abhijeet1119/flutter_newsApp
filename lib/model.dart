class NewsQueryModel
{
  String newsHead;
  String newsDes;
  String newsImg;
  String newsUrl;
  NewsQueryModel({ this.newsHead = "NEWS HEADLINE" ,  this.newsDes = "SOME NEWS" ,  this.newsImg = "SOME URL" , this.newsUrl = "SOME URL"});

  factory NewsQueryModel.fromMap(Map news)
  {
    return NewsQueryModel(
        newsHead: news["title"],
        newsDes: news["description"],
        newsImg: news["urlToImage"],
        newsUrl: news["url"]
    );
  }
}