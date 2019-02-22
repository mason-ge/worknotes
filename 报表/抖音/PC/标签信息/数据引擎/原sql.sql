SELECT DISTINCT
	t.tag_name
FROM
	lecture_tags t
WHERE
	t.app_id = 'csb'
AND t.del_flag = 0
AND t.tag_type = '1'