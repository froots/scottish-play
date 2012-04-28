(function() {
  var App = Backbone.View.extend({
    initialize: function() {
      this.views = {};
      this.models = {};
      this.on('login', this.showSortingView, this);
    },

    showSortingView: function() {
      var vent = Shake.getVent();
      this.views.sortingView = new SortingView();
      this.views.sortingView.render().$el.appendTo(this.$el);
      vent.trigger("client-player:register", vent.members.me.info.name);
      // use below to save player details to model
      // vent.bind('pusher:subscription_succeeded', this.onRegister, this);
    },

    onRegister: function() {
      var vent = Shake.Vent;
      console.log(vent.members.me);
    }
  }),

  Router = Backbone.Router.extend({ 
    routes: {
      "": "index"
    },

    index: function() {
      app.views.enterView = new EnterView().render().$el.appendTo(app.$el);
    }
  }),

  // Models
  Player = Backbone.Model.extend({}),


  // Views
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
          app.models.player = new Player({ screenName: screenName });
          app.trigger('login');
          view.remove();
        },
        error: function() {
          view.$('.message').text('Dissembling harlot, thou art false in all!');
        }
      });
    }
  }),

  SortingView = Backbone.View.extend({
    tagName: 'div',
    className: 'sorting',

    initialize: function() {
      this.tmpl = _.template($('#tmpl-sorting').html());
    },

    render: function() {
      this.$el.html(this.tmpl());
      return this;
    }
  }),

  app;

  $(function() {
    app = new App({el: document.getElementById('main')});
    app.router = new Router();
    Backbone.history.start({pushState: true});
  });
})();