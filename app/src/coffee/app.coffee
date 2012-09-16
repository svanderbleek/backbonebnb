$ ->
  Listing = Backbone.Model.extend()

  Listings = Backbone.Collection.extend
    initialize: ->
      _(10).times => 
        @add new Listing()

    update: (listings) ->
      for modelDataPair in _.zip(@toArray(), listings)
        modelDataPair[0].set modelDataPair[1].listing
  
  ListingView = Backbone.View.extend
    tagName: "li"

    className: "listing"
    
    template: _.template $("#listing-template").html()

    render: ->
      @$el.html @template @model.toJSON()
      @

  ListingsView = Backbone.View.extend
    el: "#listings"

    initialize: ->
      @subviews = _([])
      @collection.each (model) =>
        view = new ListingView model: model
        @subviews.push view 
        @$el.append view.$el

    render: ->
      @subviews.each (view) -> view.render()

        
  ListingsCountView = Backbone.View.extend
    el: "#result .count"

    render: ->
      @$el.html @model.listings_count

  ListingsSearch = Backbone.Model.extend
    urlRoot: "https://api.airbnb.com/v1/listings/search"

    initialize: ->
      @listingsCollection = new Listings()
      @listingsView = new ListingsView collection: @listingsCollection
      @listingsCountView = new ListingsCountView model: @ 

    search: ->
      @fetch
        dataType: "jsonp"
        data: 
          key: "bcxkf89pxe8srriv8h3rj7w9t" 
          location: "test"

  search = new ListingsSearch()

  search.on "change:listings", ->
    @listingsCollection.update @get "listings"
    @listingsView.render()

  search.on "change:listings_count", ->
    @listingsCountView.render()

  window.search = search
