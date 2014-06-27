# Description:
#   Messing around with Scrapyd
#
# Dependencies:
#   None
#
# Configuration:
#   SCRAPED_URL
#
# Todo:
#   clean up dup code
#
# Commands:
#   hubot scrape projects - list projects
#   hubot scrape spiders - List available spiders for a given project
#   hubot scrape versions - Get the list of versions available for some project. The versions are returned in order, the last one is the currently used version.
#   hubot scrape jobs - Get the list of pending, running and finished jobs of some project
#   hubot scrape run <spider_name> - Schedule a spider to run
#   hubot scrape cancel <jobid> - cancel a running job
#
# Author:
#   jayzeng (jayzeng@jay-zeng.com)

module.exports = (robot) ->
  robot.respond /(scrape|s)( projects)/i, (msg) ->
    if not process.env.SCRAPED_URL?
        msg.send "SCRAPED_URL is not set"
        return

    scraping_host = process.env.SCRAPED_URL
    msg.http(scraping_host + "/listprojects.json")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        if err or body.error
          msg.send "Failed to fetch projects '#{err}'"
          return

        projects = body.projects

        unless projects?
          msg.send "No project is deployed"
          return

        msg.send "Available project(s): '#{projects}'"

  robot.respond /(scrape|s)( spiders)/i, (msg) ->
    if not process.env.SCRAPED_URL?
        msg.send "SCRAPED_URL is not set"
        return

    scraping_host = process.env.SCRAPED_URL

    msg.http(scraping_host + "/listspiders.json?project=ContentScraper")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        if err or body.error
          msg.send "Failed to fetch spiders '#{err}"
          return

        spiders = body.spiders

        unless spiders?
          msg.send "No Spider is created"
          return

        return msg.send "Available spiders(s): '#{spiders}'"

  robot.respond /(scrape|s)( versions)/i, (msg) ->
    if not process.env.SCRAPED_URL?
        msg.send "SCRAPED_URL is not set"
        return

    scraping_host = process.env.SCRAPED_URL

    msg.http(scraping_host + "/listversions.json?project=ContentScraper")
      .get() (err, res, body) ->
        body = JSON.parse(body)
        if err or body.error
          msg.send "Failed to fetch spiders '#{err}"
          return

        versions = body.versions

        unless versions?
          msg.send "No Version is created"
          return

        return msg.send "Available version(s): '#{versions}'"

  robot.respond /(scrape|s)( jobs)/i, (msg) ->
    if not process.env.SCRAPED_URL?
        msg.send "SCRAPED_URL is not set"
        return

    scraping_host = process.env.SCRAPED_URL

    msg.http(scraping_host + "/listjobs.json?project=ContentScraper")
      .get() (err, res, body) ->
        body = JSON.parse(body)

        # Pending, Running, Finished
        if body.pending && body.pending.length
            msg.send 'Pending jobs \n' + JSON.stringify(body.pending)
        if body.running && body.running.length
            msg.send 'Running jobs \n' + JSON.stringify(body.running)
        if body.finished && body.finished.length
            msg.send 'Finished jobs \n' + JSON.stringify(body.finished)
        return

  robot.respond /(scrape|s)( run) (.*)?/i, (msg) ->
    if not process.env.SCRAPED_URL?
        msg.send "SCRAPED_URL is not set"
        return

    scraping_host = process.env.SCRAPED_URL

    spider_name = msg.match[3].trim()
    data="project=ContentScraper&spider=#{spider_name}"

    msg.http(scraping_host + "/schedule.json")
      .header("content-length",data.length)
      .header("Content-Type","application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        body = JSON.parse(body)

        if err or body.error
          msg.send "Failed to schedule spider '#{err}'"
          return

        return msg.send "Added #{spider_name} to the queue, job id: " + body.jobid

  robot.respond /(scrape|s)( cancel) (.*)?/i, (msg) ->
    if not process.env.SCRAPED_URL?
        msg.send "SCRAPED_URL is not set"
        return

    scraping_host = process.env.SCRAPED_URL
    jobid = msg.match[3].trim()
    data="project=ContentScraper&job=#{jobid}"

    msg.http("http://scrape.zipdigs.com:6800/cancel.json")
      .header("content-length",data.length)
      .header("Content-Type","application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        if err or body.error
          msg.send "Failed to schedule spider '#{err}'"
          return

        msg.send "Cancelling job"
        msg.send JSON.stringify(body)
        return
