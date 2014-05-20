/* global moment */
export default Ember.Handlebars.makeBoundHelper(function(val) {
  return moment(val).fromNow();
});
