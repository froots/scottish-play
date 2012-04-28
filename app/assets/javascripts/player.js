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
      this.views.sorting = new SortingView();
      this.views.sorting.render().$el.appendTo(this.$el);
      
      // use below to save player details to model
      vent.bind('pusher:subscription_succeeded', $.proxy(this.onRegister, this));
    },

    onRegister: function() {
      var vent = Shake.Vent,
          name = vent.members.me.info.name,
          player = this.models.player;

      player.set({ name: name });

      vent.trigger("client-player:register", { user_id: name });
      this.assignRoleProxy = $.proxy(this.onAssignRole, this);
      vent.bind("client-player:assignRole", this.assignRoleProxy);
    },

    onAssignRole: function(data) {
      var vent = Shake.Vent,
          player = this.models.player;
      if (data.user_id === player.get('name')) {
        player.set({ role: data.role });
        this.views.sorting.$el.hide();
        if (data.character && !('characterView' in this.views)) {
          player.set({ character: data.character });
          this.views.characterView = new CharacterView({
            model: player
          });
          this.views.characterView.render().$el.appendTo(this.$el);
          this.onGameStartProxy = $.proxy(this.onGameStart, this);
        } else if (!('audienceView' in this.views)) {
          this.views.audienceView = new AudienceView({
            model: player
          });
          this.views.audienceView.render().$el.appendTo(this.$el);
        }
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
      var vent = Shake.Vent;
      _.bindAll(this, "onPlayerDeliver", "onSceneEnd");
      this.tmpl = JST['templates/character'];
      vent.bind("client-player:deliver", this.onPlayerDeliver);
      vent.bind("client-scene:end", this.onSceneEnd);
    },

    render: function() {
      this.$el.html(this.tmpl(this.model.toJSON()));
      this.$waiting = this.$('.waiting');
      this.$yourTurn = this.$('.your-turn');
      this.$otherTurn = this.$('.other-turn');
      this.$end = this.$('.end');
      return this;
    },

    onPlayerDeliver: function(data) {
      this.$waiting.hide();
      console.log(data);
    }
  }),

  AudienceView = Backbone.View.extend({
    tagName: 'div',
    className: 'audience',

    initialize: function() {
      var vent = Shake.Vent;
      _.bindAll(this, "onSceneStart", "onSceneEnd");
      this.tmpl = JST['templates/audience'];
      this.vegHurled = 0;
      this.flowersHurled = 0;
      vent.bind("client-scene:start", this.onSceneStart);
      vent.bind("client-scene:end", this.onSceneEnd);
    },

    events: {
      'click .tomato': 'throwTomato',
      'click .flowers': 'throwFlowers'
    },

    render: function() {
      this.$el.html(this.tmpl(this.model.toJSON()));
      this.$waiting = this.$('.waiting');
      this.$vote = this.$('.vote');
      this.$end = this.$('.end');
      return this;
    },

    onSceneStart: function() {
      this.$waiting.hide();
      this.$end.hide();
      this.$vote.show();
    },

    throwTomato: function(ev) {
      this.throwObject('veg');
      this.vegHurled++;
    },

    throwFlowers: function() {
      this.throwObject('flowers');
      this.flowersHurled++;
    },

    throwObject: function(obj) {
      Shake.Vent.trigger("client-player:hurl", {
        user_id: this.model.get('name'),
        object: obj
      });
    },

    onSceneEnd: function() {
      this.$end.find('.veg-count').text(this.vegHurled);
      this.$end.find('.flowers-count').text(this.flowersHurled);
      this.$end.show();
      this.$waiting.hide();
      this.$vote.hide();
    }
  }),

  app;

  $(function() {
    app = new App({el: document.getElementById('main')});
    app.router = new Router();
    Backbone.history.start({pushState: true});
  });
})();
