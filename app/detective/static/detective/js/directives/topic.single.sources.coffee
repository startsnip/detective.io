# this directive help us to display a display popover for our sources
angular.module('detective.directive').directive 'sourcesPopover', ['UtilsFactory', (UtilsFactory)->
    restrict: "A"
    templateUrl: "partial/topic.single.sources.html"
    replace: true
    scope:
        sources: '=sourcesList'
        orientation: '=?sourcesPopoverOrientation'
    controller: ["$scope", ($scope)->
        $scope.isSourceURLValid = (source)=>
            UtilsFactory.isValidURL(source.reference)
    ]
]