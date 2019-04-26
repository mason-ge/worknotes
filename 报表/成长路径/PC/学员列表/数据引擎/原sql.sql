SELECT
	TBL.*
FROM
	(
		SELECT
			t1.user_id,
			u1.login_name,
			u1. NAME AS user_name,
			u1.user_post,
			o1.`name` AS org_name,
			t2.path_name,
			t3. NAME AS checkpoint_name,
			t4.assess_user_id,
			u2. NAME AS assess_user_name,
			t4.teaching_user_id,
			u3.`name` AS teaching_user_name,
			t4.exercise_assess_user1,
			u4.`name` AS exercise_assess_name1,
			t4.exercise_assess_user2,
			u5.`name` AS exercise_assess_name2,
			t1.exam_high_score AS exam_score,
			ifnull(TBS.assess_score, 0) AS assess_score,
			(
				CASE
				WHEN t1.checkpoint_flag IN ('0', '1') THEN
					'未开始'
				WHEN t1.checkpoint_flag = '2' THEN
					'进行中'
				WHEN t1.checkpoint_flag = '3' THEN
					'已通过'
				ELSE
					''
				END
			) AS ck_flag,
			t1.checkpoint_flag,
			t1.growup_path_id,
			t1.growup_level_id,
			t1.checkpoint_id,
			t2.disabled
		FROM
			growup_checkpoint_detail t1
		LEFT JOIN growup_path t2 ON t1.growup_path_id = t2.growup_path_id
		LEFT JOIN growup_checkpoint t3 ON t1.checkpoint_id = t3.checkpoint_id
		LEFT JOIN growup_checkpoint_man_detail t4 ON t1.user_id = t4.user_id
		AND t1.checkpoint_id = t4.checkpoint_id
		LEFT JOIN (
			SELECT
				sum(score) AS assess_score,
				user_id,
				checkpoint_id
			FROM
				growup_task_assess_detail
			WHERE
				app_id = 'csb'
			GROUP BY
				checkpoint_id,
				user_id
		) TBS ON (
			t1.user_id = TBS.user_id
			AND t1.checkpoint_id = TBS.checkpoint_id
		)
		LEFT JOIN sys_user u1 ON (t1.user_id = u1.sys_user_id)
		LEFT JOIN sys_org_shop o1 ON (
			u1.belong_org = o1.sys_org_id
		)
		LEFT JOIN sys_user u2 ON (
			t4.assess_user_id = u2.sys_user_id
		)
		LEFT JOIN sys_user u3 ON (
			t4.teaching_user_id = u3.sys_user_id
		)
		LEFT JOIN sys_user u4 ON (
			t4.exercise_assess_user1 = u4.sys_user_id
		)
		LEFT JOIN sys_user u5 ON (
			t4.exercise_assess_user2 = u5.sys_user_id
		)
		WHERE
			t1.app_id = 'csb'
	) TBL