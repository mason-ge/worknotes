SELECT
	TBL.*
FROM
	(
		SELECT
			t.content_title AS content_title,
			e.lecturer_name AS create_user,
			t.create_time AS create_time,
			t.favorite_num AS favorite_num,
			t.comment_num AS comment_num,
			t.like_num AS like_num,
			t.click_num AS click_num,
			t.reward_num AS reward_num,
			t.recommend_index AS recommend_index,
			TBG.tag_name AS tag_name
		FROM
			lecture_content t
		LEFT JOIN lecture_lecturer e ON (
			e.lecturer_id = t.lecturer_id
		)
		LEFT JOIN (
			SELECT
				GROUP_CONCAT(ta.tag_name) AS tag_name,
				tad.content_id,
				tad.app_id
			FROM
				lecture_tags ta
			LEFT JOIN lecture_tags_detail tad ON (
				ta.tag_id = tad.tag_id
				AND ta.app_id = tad.app_id
			)
			WHERE
				1 = 1
			AND ta.app_id = 'csb'
			GROUP BY
				tad.content_id,
				tad.app_id
		) TBG ON (
			TBG.content_id = t.content_id
			AND TBG.app_id = t.app_id
		)
		WHERE
			1 = 1
		AND t.app_id = 'csb'
		AND t.del_flag = '0'
		ORDER BY
			t.create_time DESC
	) TBL