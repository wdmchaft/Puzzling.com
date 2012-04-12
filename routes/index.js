
/*
 * GET home page.
 */

exports.index = function(req, res){
  /* res.render takes a string that corresponds
   * to a .jade page in the views module,
   * and a dictionary of parameters.
   */
  res.render('index',
              { title: 'Express' })
};
