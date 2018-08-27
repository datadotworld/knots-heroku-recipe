# KNOTS Heroku Recipe

Executes a KNOTS pipeline in a Heroku environment.

## Getting Started

1. Create a [KNOTS](https://github.com/singer-io/knots) pipeline.
2. Click this button and drop zip in the heroku folder.
3. You will need your own [Heroku](https://www.heroku.com) account. The account will need to be
[verified](https://devcenter.heroku.com/articles/account-verification), meaning that you'll need to put in your credit
card info, although it's highly unlikely that you'll go past the bounds of the free tier.
4. Deploy to Heroku by pressing the fancy-looking button above
    * This integration was designed to save all of the Redshift tables into one dataset, but can be configured to save
    to multiple datasets. Take a look at the [Storing Tables in Multiple Datasets](#storing-tables-in-multiple-datasets)
    section.
    * Take a look at the [Config Vars](#config-vars) section for more details on the individual configuration variables
5. Once deployment is done, click on 'Manage App' to go to the app's 'Overview' page
6. Under 'Installed add-ons', click on 'Heroku Scheduler' (Scrap that; instead, add the addon)
7. Add a new job. The command to use is `make update`.
    * Note that this will fetch all of the data from your Redshift database every time. A better process would be to
    fetch only the data that has been updated since last run. Take a look at the [Incremental Updates](#incremental-updates)
    for info on setting that up.

As an example, the following job is scheduled to run daily at 8 AM CDT:
![Daily Job](assets/scheduler-daily-job.png)
8. If you wish to get the data immediately, trigger a manual run as described in [Manual Run](#manual-run)

### Manual Run

To trigger a manual update, click on 'More' on the upper right-hand corner, and then 'Run console' (screenshot below).
Type `make update` on the screen that pops up and press 'Run'.

![Run Console](assets/run-console.png)

### Contributing

This integration has been released as an open-source project. Community participation is encouraged and highly
appreciated. If you'd like to contribute, please follow the [Contributing Guidelines](CONTRIBUTING.md).

### Support

For support, either create a [new issue](https://github.com/datadotworld/knots-heroku-recipe/issues) here on
GitHub, or send an email to help@data.world.
