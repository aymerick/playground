App = Ember.Application.create();

App.Router.map(function(){
    this.resource('about');
    this.resource('posts', function() {
        this.resource('post', { path: ':post_id' });
    });
});

App.PostsRoute = Ember.Route.extend({
    model: function(){
        // return posts;

        return $.getJSON('http://tomdale.net/api/get_recent_posts/?callback=?').then(function(data) {
            return data.posts.map(function(post) {
                post.body = post.content;
                return post;
            });
        });
    }
});

App.PostRoute = Ember.Route.extend({
    model: function(params){
        // return posts.findBy('id', params.post_id);

        return $.getJSON('http://tomdale.net/api/get_post/?id=' + params.post_id + '&callback=?').then(function(data) {
            data.post.body = data.post.content;
            return data.post;
        });
    }
});

App.PostController = Ember.ObjectController.extend({
    isEditing: false,

    actions: {
        edit: function() {
            this.set('isEditing', true);
        },

        doneEditing: function() {
            this.set('isEditing', false);
        }
    }
});

Ember.Handlebars.helper('format-date', function(date) {
    return moment(date).fromNow();
});

var showdown = new Showdown.converter();

Ember.Handlebars.helper('format-markdown', function(input) {
    return new Handlebars.SafeString(showdown.makeHtml(input));
});

// var posts = [{
//     id: '1',
//     title: "Pouet pouet lala",
//     author: { name: "Jean Mich" },
//     date: new Date('12-27-2012'),
//     excerpt: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sit amet adipiscing libero. Phasellus vel posuere enim, vel feugiat nisi. Donec pellentesque fringilla odio sit amet sollicitudin. Nunc sed ornare leo, id laoreet lorem. Vestibulum urna massa, vulputate ut diam sit amet, sollicitudin porta lectus. Fusce id sapien ut turpis elementum eleifend ut nec ligula. Aliquam convallis tortor at diam convallis hendrerit.",
//     body: "Curabitur ultricies arcu at erat [ullamcorper](http://www.fotonauts.com), eget vestibulum purus gravida. Quisque pulvinar hendrerit arcu, nec ultrices tellus porta sit amet. Nam luctus justo eu felis condimentum tristique. Integer porta neque vitae eleifend pulvinar. Ut vel dui nisl. Cras magna tortor, euismod ut odio ac, mattis blandit urna. Suspendisse eu molestie odio. Etiam tempus, lectus in rhoncus faucibus, risus eros imperdiet magna, id elementum velit odio id neque. Cras in urna consequat, consectetur sem vitae, rhoncus nunc. Nunc lobortis ac mi a elementum. Suspendisse pulvinar aliquet convallis."
// }, {
//     id: '2',
//     title: "ROooOOoo",
//     author: { name: "Charles Edouard" },
//     date: new Date('12-24-2012'),
//     excerpt: "Integer eget nisl non sapien placerat fermentum. Nunc eu felis at nisi ornare condimentum sed at turpis. Suspendisse scelerisque neque eu diam sodales, et sodales velit venenatis.",
//     body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ultricies [auctor orci quis congue](http://www.aymerick.com). Phasellus vel lorem hendrerit, accumsan sapien in, dapibus nibh. Donec id elit id est laoreet luctus. Nam commodo arcu congue dolor blandit, nec congue nunc ultrices. Maecenas placerat augue leo, vitae tempus sem rhoncus at. Phasellus dictum vitae sapien eget consectetur. Nam sollicitudin urna sed dui blandit ullamcorper vel id orci. Nulla venenatis porttitor ligula vitae gravida. Sed blandit facilisis vulputate. Vivamus eu condimentum eros. Nulla eget pellentesque lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
// }];
