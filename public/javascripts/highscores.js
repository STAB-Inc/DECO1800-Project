// Generated by CoffeeScript 1.12.7

/*
@file
Generates the appropiate view for highscores.html
 */

(function() {
  $(document).ready(function() {

    /*
      Sorts an array by the first element of the array.
     */
    var sortDec, submitUserData;
    sortDec = function(a, b) {
      var ref;
      if (a[0] === b[0]) {
        return 0;
      } else {
        return (ref = a[0] < b[0]) != null ? ref : -{
          1: 1
        };
      }
    };

    /*
      Submits session data to the server. 
      @param {Object} data - the data to be submitted.
      @return AJAX deferred promise.
     */
    submitUserData = function(data) {
      return $.ajax({
        url: '/routes/user.php',
        type: 'POST',
        data: data
      });
    };

    /*
      Generates the elements containing the highscores info by requesting the apporiate data.
     */
    return submitUserData({
      method: 'getAll'
    }).then(function(res) {
      var userData;
      userData = JSON.parse(res);
      return submitUserData({
        method: 'getActiveUser'
      }).then(function(user) {
        var data, gameScore, i, j, k, key, len, len1, len2, ref, ref1, results, score, scores, userId;
        user = JSON.parse(user);
        userId = user.message;
        gameScore = {
          g1: [],
          g2: [],
          g3: [],
          g4: []
        };
        ref = Object.keys(gameScore);
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          key = ref[i];
          for (j = 0, len1 = userData.length; j < len1; j++) {
            data = userData[j];
            ref1 = data.scores[key];
            for (k = 0, len2 = ref1.length; k < len2; k++) {
              scores = ref1[k];
              gameScore[key].push([parseInt(scores[0]), scores[1], data.username, data.id]);
            }
          }
          results.push((function() {
            var l, len3, ref2, results1;
            ref2 = gameScore[key].sort(sortDec);
            results1 = [];
            for (l = 0, len3 = ref2.length; l < len3; l++) {
              score = ref2[l];
              if (userId === score[3]) {
                results1.push($('.' + key).append($('<div class="row current"> <div class="col-lg-4"> <p>' + score[2] + '</p> </div> <div class="col-lg-4"> <p>' + score[0] + '</p> </div> <div class="col-lg-4"> <p class="date">' + score[1] + '</p> </div> </div>')));
              } else {
                results1.push($('.' + key).append($('<div class="row"> <div class="col-lg-4"> <p>' + score[2] + '</p> </div> <div class="col-lg-4"> <p>' + score[0] + '</p> </div> <div class="col-lg-4"> <p class="date">' + score[1] + '</p> </div> </div>')));
              }
            }
            return results1;
          })());
        }
        return results;
      });
    });
  });

}).call(this);
