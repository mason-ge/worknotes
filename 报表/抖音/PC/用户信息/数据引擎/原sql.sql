SELECT
	TBL.*
FROM
	(
		SELECT
			t.lecturer_name AS user_name,
			t.login_name AS login_name,
			t.effective_time,
			(
				CASE
				WHEN t.effective_time > CURRENT_TIME () THEN
					'禁言'
				ELSE
					'正常'
				END
			) AS STATUS,
			t.belong_org_name AS belong_org_name,
			t.aggregative_indc AS hot_num,
			t.fans_num AS fans_num,
			t.course_num AS course_num,
			t.recommend_flag as recommend_flag,
			(
				CASE
				WHEN t.effective_time > CURRENT_TIME () THEN
					DATEDIFF(
						t.effective_time,
						CURRENT_TIME
					)
				ELSE
					NULL
				END
			) AS diff_days
		FROM
			lecture_lecturer t
		WHERE
			1 = 1
		AND t. STATUS <> 3
		AND t.app_id = 'csb'
        order by t.recommend_flag
	) TBL
