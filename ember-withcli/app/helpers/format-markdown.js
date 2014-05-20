/* global Showdown */
/* global Handlebars */

var showdown = new Showdown.converter();

export default Ember.Handlebars.makeBoundHelper(function(val) {
  return new Handlebars.SafeString(showdown.makeHtml(val));
});
