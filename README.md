# Hubot Scrapyd

Scrapyd commands for hubot!

## Installation

Add **hubot-scrapyd** to your `package.json` file:

```json
"dependencies": {
  "hubot": ">= 2.5.1",
  "hubot-scripts": ">= 2.4.2",
  "hubot-scrapyd": ">= 0.0.0"
}
```

Add **hubot-scrapyd** to your `external-scripts.json`:

```json
["hubot-scrapyd"]
```

Run `npm install hubot-scrapyd`

Set SCRAPED_URL as environmental variable.

E.g (Heroku)
heroku config:set SCRAPED_URL=http://scrape.mywebsite.com:6800

## Commands

```
# Commands:
hubot scrape projects - list projects
hubot scrape spiders - List available spiders for a given project
hubot scrape versions - Get the list of versions available for some project. The versions are returned in order, the last one is the currently used version.
hubot scrape jobs - Get the list of pending, running and finished jobs of some project
hubot scrape run <spider_name> - Schedule a spider to run
hubot scrape cancel <jobid> - cancel a running job
```

## Contributing

* Fork this repo
* Submit your code to your fork
* Create a pull request from your fork

## API
The Scrapyd API can be found at:
http://scrapyd.readthedocs.org/en/latest/api.html

https://github.com/jayzeng/scrapyd-bot

Feel free to contribute there as well, following the same steps above in `Contributing`
