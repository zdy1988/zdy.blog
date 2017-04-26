<!-- custom analytics part create by xiamo -->
<script src="https://cdn1.lncld.net/static/js/av-core-mini-0.6.1.js"></script>
<script>AV.initialize("{{theme.leancloud_visitors.app_id}}", "{{theme.leancloud_visitors.app_key}}");</script>
<script>
function showTime(Counter) {
	var query = new AV.Query(Counter);
	$(".leancloud_visitors").each(function() {
    var self = this
		var url = $(this).attr("id").trim();
		query.equalTo("url", url);
		query.find({
			success: function(results) {
				if (results.length == 0) {
					$(self).find('.leancloud-visitors-count').text(0);
				}else{
				 $(self).find('.leancloud-visitors-count').text(results[0].get('time'));
        }
			},
			error: function(object, error) {
				console.log("Error: " + error.code + " " + error.message);
			}
		});

	});
}

function addCount(Counter) {
	var Counter = AV.Object.extend("Counter");
	url = $(".leancloud_visitors").attr('id').trim();
	title = $(".leancloud_visitors").attr('data-flag-title').trim();
	var query = new AV.Query(Counter);
	query.equalTo("url", url);
	query.find({
		success: function(results) {
			if (results.length > 0) {
				var counter = results[0];
				counter.fetchWhenSave(true);
				counter.increment("time");
				counter.save(null, {
					success: function(counter) {
						$(document.getElementById(url)).find('.leancloud-visitors-count').text(counter.get('time'));
					},
					error: function(counter, error) {
						console.log('Failed to save Visitor num, with error message: ' + error.message);
					}
				});
			} else {
				var newcounter = new Counter();
				newcounter.set("title", title);
				newcounter.set("url", url);
				newcounter.set("time", 1);
				newcounter.save(null, {
					success: function(newcounter) {
            $(document.getElementById(url)).find('.leancloud-visitors-count').text(newcounter.get('time')); 
					},
					error: function(newcounter, error) {
						console.log('Failed to create');
					}
				});
			}
		},
		error: function(error) {
			console.log('Error:' + error.code + " " + error.message);
		}
	});
}
$(function() {
	var Counter = AV.Object.extend("Counter");
	if ($('.leancloud_visitors').length == 1) {
		addCount(Counter);
	} else if ($('.post-title-link').length > 1) {
		showTime(Counter);
	}
}); 
</script>