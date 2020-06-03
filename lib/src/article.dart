class Article {
  final String text;
  final String url;
  final String by;
  final String age;
  final int score;
  final int commentsCount;

  const Article(
      {this.age, this.url, this.by, this.commentsCount, this.score, this.text});

  factory Article.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return Article(
      text: json['text'] ?? [null],
      url: json['url'],
      by: json['by'],
    );
  }
}

final articles = [
  new Article(
    text:
        'Ministro pede à PF investigação sobre vazamento de supostos dados de Bolsonaro e filhos',
    url: 'g1.globo.com',
    by: 'globo',
    age: '3 hours',
    score: 287,
    commentsCount: 128,
  ),
  new Article(
    text:
        'Circular Shock Acoustic Waves in Ionosphere triggered by Launch of Formosat - 5',
    url: 'wiley.com',
    by: 'zdw',
    age: '3 hours',
    score: 177,
    commentsCount: 62,
  ),
  new Article(
    text: 'The Boring Flutter Development Show [Pilot Episode]',
    url: 'www.youtube.com',
    by: 'zdw',
    age: '3 hours',
    score: 177,
    commentsCount: 62,
  ),
  new Article(
    text: 'BMW says electric car mass production not viable until 2020',
    url: 'reuters.com',
    by: 'Mononokay',
    age: '2 hours',
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: 'BMW says electric car mass production not viable until 2020',
    url: 'reuters.com',
    by: 'Mononokay',
    age: '2 hours',
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: 'Evolution Is the New Deep Learning',
    url: 'sentient.ai',
    by: 'jonbaer',
    age: '4 hours',
    score: 200,
    commentsCount: 87,
  ),
  new Article(
    text: 'TCP Tracepoints have arrived in Linux',
    url: 'brendangregg.com',
    by: 'brendangregg',
    age: '1 hours',
    score: 35,
    commentsCount: 0,
  ),
  new Article(
    text:
        'Section 230: A Key Legal Shield for Facebook, Google Is about to Change,',
    url: 'github.com',
    by: 'bluzi',
    age: '8 hours',
    score: 37,
    commentsCount: 26,
  ),
  new Article(
    text: 'A Visiting Star jostled our solar System 70,000 Years Ago,',
    url: 'gizmodo.com',
    by: 'rbanffy',
    age: '7 hours',
    score: 42,
    commentsCount: 18,
  ),
  new Article(
    text: 'Using technical Debt in Your Favor',
    url: 'gitconnected.com',
    by: 'treyhuffine',
    age: '7 hours',
    score: 140,
    commentsCount: 123,
  ),
  new Article(
    text:
        'Circular Shock Acoustic Waves in Ionosphere triggered by Launch of Formosat - 5',
    url: 'wiley.com',
    by: 'zdw',
    age: '3 hours',
    score: 177,
    commentsCount: 62,
  ),
  new Article(
    text: 'BMW says electric car mass production not viable until 2020',
    url: 'reuters.com',
    by: 'Mononokay',
    age: '2 hours',
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: 'BMW says electric car mass production not viable until 2020',
    url: 'reuters.com',
    by: 'Mononokay',
    age: '2 hours',
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: 'Evolution Is the New Deep Learning',
    url: 'sentient.ai',
    by: 'jonbaer',
    age: '4 hours',
    score: 200,
    commentsCount: 87,
  ),
  new Article(
    text: 'TCP Tracepoints have arrived in Linux',
    url: 'brendangregg.com',
    by: 'brendangregg',
    age: '1 hours',
    score: 35,
    commentsCount: 0,
  ),
  new Article(
    text:
        'Section 230: A Key Legal Shield for Facebook, Google Is about to Change,',
    url: 'github.com',
    by: 'bluzi',
    age: '8 hours',
    score: 37,
    commentsCount: 26,
  ),
  new Article(
    text: 'A Visiting Star jostled our solar System 70,000 Years Ago,',
    url: 'gizmodo.com',
    by: 'rbanffy',
    age: '7 hours',
    score: 42,
    commentsCount: 18,
  ),
  new Article(
    text: 'Using technical Debt in Your Favor',
    url: 'gitconnected.com',
    by: 'treyhuffine',
    age: '7 hours',
    score: 140,
    commentsCount: 123,
  ),
  new Article(
    text:
        'Circular Shock Acoustic Waves in Ionosphere triggered by Launch of Formosat - 5',
    url: 'wiley.com',
    by: 'zdw',
    age: '3 hours',
    score: 177,
    commentsCount: 62,
  ),
  new Article(
    text: 'BMW says electric car mass production not viable until 2020',
    url: 'reuters.com',
    by: 'Mononokay',
    age: '2 hours',
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: 'BMW says electric car mass production not viable until 2020',
    url: 'reuters.com',
    by: 'Mononokay',
    age: '2 hours',
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: 'Evolution Is the New Deep Learning',
    url: 'sentient.ai',
    by: 'jonbaer',
    age: '4 hours',
    score: 200,
    commentsCount: 87,
  ),
  new Article(
    text: 'TCP Tracepoints have arrived in Linux',
    url: 'brendangregg.com',
    by: 'brendangregg',
    age: '1 hours',
    score: 35,
    commentsCount: 0,
  ),
  new Article(
    text:
        'Section 230: A Key Legal Shield for Facebook, Google Is about to Change,',
    url: 'github.com',
    by: 'bluzi',
    age: '8 hours',
    score: 37,
    commentsCount: 26,
  ),
  new Article(
    text: 'A Visiting Star jostled our solar System 70,000 Years Ago,',
    url: 'gizmodo.com',
    by: 'rbanffy',
    age: '7 hours',
    score: 42,
    commentsCount: 18,
  ),
  new Article(
    text: 'Using technical Debt in Your Favor',
    url: 'gitconnected.com',
    by: 'treyhuffine',
    age: '7 hours',
    score: 140,
    commentsCount: 123,
  ),
];
