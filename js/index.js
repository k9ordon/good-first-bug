App = Ember.Application.create();

Ember.RSVP.configure('onerror', function(error) {
	if (error instanceof Error) {
		Ember.Logger.assert(false, error);
		Ember.Logger.error(error.stack);
	}
});

App.Adapter = {
	ajax: function(path, options) {
		var options = options || {};
		options.dataType = 'json';
		return Ember.$.ajax('https://api.github.com' + path, options)
	}
}

App.Issue = Ember.Object.extend({
	id: null,

	githubUrl: null,
	title: null,
	body: null,

	labels: null,

	repoId: function() {
		return this.get('githubUrl').split('/')[4];
	}.property('githubUrl'),

	repoOwnerId: function() {
		return this.get('githubUrl').split('/')[3];
	}.property('githubUrl'),
});
/*
App.Issue.reopenClass({
	createRecord: function(data) {
		alert(data);
		return App.Bug.create({ id: data.id, title: data.title, githubUrl: data.html_url, body: data.body });
	}
});
*/
App.IssuesList = Ember.Object.extend({
	title: 'All',
	count: null,
	issues: [],

	slug: function() {
		return this.get('title').dasherize();
	}.property('title')
});

App.IssuesList.reopenClass({
  createRecord: function(data) {
	console.log('IssueList createRecord', data);

    var list = App.IssuesList.create({ count: data.total_count, title: 'Ajax ...' });
    list.set('issues', this.extractItems(data.items, list));
    return list;
  },

  extractItems: function(issueItems, issueList) {
    return issueItems.map(function(issue) {

      	return App.Issue.create({ id: issue.id, title: issue.title, githubUrl: issue.html_url, body: issue.body, labels: issue.labels });
    });
  }
});

App.Router.map(function() {
	this.resource('issues', function() {
		//this.resource('bug', { path: ':slug' }, function() {});
	});
});

App.IndexRoute = Ember.Route.extend({
	beforeModel: function() {
		this.transitionTo('issues');
	}
});

App.IssuesRoute = Ember.Route.extend({
	model: function(params) {
		return new Ember.RSVP.Promise(function(resolve, reject) {
		App.Adapter.ajax('/search/issues?q=label:"good first bug"+state:open&sort=updated&order=asc&page=1&per_page=40').then(function(data) {
			resolve(App.IssuesList.createRecord(data));
		}, function(error) {
			reject(error);
		});
		});
	}
});
