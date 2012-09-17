$ ->
  Listing = Backbone.Model.extend()

  Listings = Backbone.Collection.extend
    model: Listing

    initialize: ->
      _(10).times => 
        @add {} 

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
    el: "#count"

    render: ->
      @$el.html @model.get "listings_count"

  ListingsSearch = Backbone.Model.extend
    urlRoot: "https://api.airbnb.com/v1/listings/search"

    initialize: ->
      @listingsCollection = new Listings()
      @listingsView = new ListingsView collection: @listingsCollection
      @listingsCountView = new ListingsCountView model: @ 

    search: (params) ->
      @fetch
        dataType: "jsonp"
        data: _.extend(params, key: "bcxkf89pxe8srriv8h3rj7w9t")

  search = new ListingsSearch()

  search.on "change:listings", ->
    @listingsCollection.update @get "listings"
    @listingsView.render()
    @listingsCountView.render()

  search.on "change:listings_count", ->
    @listingsCountView.render()

  ListingsSearchView = Backbone.View.extend
    el: "#search"

    events:
      "click #search-button": "search"

    initialize: ->
      @location = $ "#location"

    search: ->
      @model.search 
        location: @location.val()

  new ListingsSearchView model: search
