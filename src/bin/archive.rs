fn main() {
    use std::io::{self, Read};
    let mut buffer = Vec::new();
    io::stdin()
        .read_to_end(&mut buffer)
        .expect("Failed to read line");

    let buffer = String::from_utf8_lossy(&buffer);
    dbg!(&buffer);

    let payload: serde_json::Value = serde_json::from_str(&buffer).unwrap();
    dbg!(&payload);

    let url = payload["url"].as_str().unwrap();
    dbg!(&url);
}

/*
fn calc_hash(url: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(url);
    let hash = format!("{:x}", hasher.finalize());
    hash[..12].to_string()
}

fn read_later(url: &str) -> Option<serde_json::Value> {
    let hash = calc_hash(&url);
    let metadata = fetch_duplicate(&hash);
    if metadata.is_some() {
        println!("is duplicate");
        return metadata;
    }

    let client = reqwest::blocking::Client::builder()
        .cookie_store(true)
        .build()
        .unwrap();
    let url = Url::parse(url).unwrap();
    let content = client.get(url.clone()).send().unwrap().text().ok()?;
    // let md = html2md::rewrite_html_custom_with_url(&content, &None, true, &Some(url.clone()));
    let md = html2md::parse_html(&content);
    let soup = Soup::new(&content);
    let title = soup.tag("title").find().expect("Couldn't find tag 'title'");
    println!("title: {}", title.text());
    let body = soup.tag("body").find().expect("Couldn't find tag 'body'");
    let body = body.text();

    let author = "todo";

    let date: DateTime<Utc> = Utc::now();

    let metadata = json!({
        "title": title.text(),
        "content_html": content,
        "content_body": body,
        "content_md": md,
        "authors": [author],
        "publish_date": date.format("%Y-%m-%dT%H:%M:%SZ").to_string(),
        "url": url.to_owned(),
        "hash": hash,
    });
    store_metadata(&metadata);
    Some(metadata)
}

*/
