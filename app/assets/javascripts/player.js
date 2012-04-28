(function() {
  var App = Backbone.View.extend({
    initialize: function() {
      this.views = {};
      this.models = {};
      this.models.player = new Player();
      this.on('login', this.showSortingView, this);
    },

    showSortingView: function() {
      var vent = Shake.getVent();
      this.views.sortingView = new SortingView();
      this.views.sortingView.render().$el.appendTo(this.$el);
      
      // use below to save player details to model
      vent.bind('pusher:subscription_succeeded', $.proxy(this.onRegister, this));
    },

    onRegister: function() {
      var vent = Shake.Vent,
          name = vent.members.me.info.name,
          player = this.models.player;

      player.set({ name: name });
      console.log(player);

      vent.trigger("client-player:register", name);
      this.assignRoleProxy = $.proxy(this.onAssignRole, this);
      vent.bind("client-player:assignRole", this.assignRoleProxy);
    },

    onAssignRole: function(data) {
      var vent = Shake.Vent,
          player = this.models.player;
      if (data.user_id === player.get('name')) {
        player.set({ role: data.role });
        if (data.character) {
          player.set({ character: data.character });
          this.views.characterView = new CharacterView({
            model: player
          });
          this.views.characterView.render().$el.appendTo(this.$el);
        } else {
          this.views.audienceView = new AudienceView({
            model: player
          });
          this.views.audienceView.render().$el.appendTo(this.$el);
        }
        // var msg = "You are in the "+data.role;
        // msg += ", playing the part of "+data.character;
      }
    }
  }),

  Router = Backbone.Router.extend({
    routes: {
      "": "index"
    },

    index: function() {
      app.views.enterView = new EnterView();
      app.views.enterView.render().$el.appendTo(app.$el);
    }
  }),

  // Models
  Player = Backbone.Model.extend({}),


  // Views
  EnterView = Backbone.View.extend({
    initialize: function() {
      this.tmpl = JST['templates/enter'];
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
      this.tmpl = JST['templates/sorting'];
    },

    render: function() {
      this.$el.html(this.tmpl());
      return this;
    }
  }),

  CharacterView = Backbone.View.extend({
    tagName: 'div',
    className: 'character',

    initialize: function() {
      this.tmpl = JST['templates/character'];
    },

    render: function() {
      this.$el.html(this.tmpl(this.model.toJSON()));
      return this;
    }
  }),

  AudienceView = Backbone.View.extend({
    tagName: 'div',
    className: 'audience',

    initialize: function() {
      this.tmpl = JST['templates/audience'];
    },

    render: function() {
      this.$el.html(this.tmpl(this.model.toJSON()));
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
