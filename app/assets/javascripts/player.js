(function() {
  var App = Backbone.View.extend({
    initialize: function() {
      this.on('login', this.showRoleChoiceView, this);
    },

    showRoleChoiceView: function() {
      console.log('roleChoiceView');
    }
  }),

  Router = Backbone.Router.extend({ 
    routes: {
      "": "index"
    },

    index: function() {
      var enterView = new EnterView().render().$el.appendTo(app.$el);
    }
  }),

  EnterView = Backbone.View.extend({
    initialize: function() {
      this.tmpl = _.template($('#tmpl-enter').html());
    },

    events: { 
      'submit form': 'onSubmit'
    },

    render: function() {
      this.$el.html(this.tmpl());
      return this;
    },

    onSubmit: function(ev) {
      ev.preventDefault();
      this.saveUser(this.$('#screenname').val());
    },

    saveUser: function(screenName) {
      var view = this;
      $.ajax({
        url: "/pusher/login", 
        data: { user_id: screenName }, 
        dataType: 'text',
        success: function() {
          app.trigger('login');
          view.remove();
        },
        error: function() {
          view.$('.message').text('Dissembling harlot, thou art false in all!');
        }
      });
    }
  }),

  app;

  $(function() {
    app = new App({el: document.getElementById('main')});
    app.router = new Router();
    Backbone.history.start({pushState: true});
  });
})();