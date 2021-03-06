SELECT
	TBL.*
FROM
	(
		SELECT
			gc. NAME AS checkpoint_name,
			gc.description AS checkpoint_desc,
			TBP1.cnt_checkpoint,
			gl.level_name,
			gl.description AS level_desc,
			TBP2.cnt_level,
			gp.path_name,
			gp.path_description AS path_desc,
			(
				CASE
				WHEN gp.path_flag = '0' THEN
					'未发布'
				WHEN gp.path_flag = '1' THEN
					'已发布'
				WHEN gp.path_flag = '2' THEN
					'失效'
				ELSE
					''
				END
			) AS path_flag,
			TBP3.cnt_path
		FROM
			(
				SELECT DISTINCT
					cp.checkpoint_id,
					td.growup_level_id,
					td.growup_path_id,
					cp.app_id
				FROM
					growup_checkpoint cp
				LEFT JOIN growup_checkpoint_detail td ON (
					cp.checkpoint_id = td.checkpoint_id
				)
				WHERE
					cp.app_id = 'csb'
				AND cp.delete_flag = '0'
			) t
		LEFT JOIN growup_checkpoint gc ON (
			t.checkpoint_id = gc.checkpoint_id
			AND t.app_id = gc.app_id
		)
		LEFT JOIN (
			SELECT
				d.checkpoint_id,
				d.app_id,
				count(DISTINCT d.user_id) AS cnt_checkpoint
			FROM
				growup_checkpoint_detail d
			WHERE
				d.app_id = 'csb'
			GROUP BY
				d.checkpoint_id,
				d.app_id
		) TBP1 ON (
			t.checkpoint_id = TBP1.checkpoint_id
			AND t.app_id = TBP1.app_id
		)
		LEFT JOIN growup_level gl ON (
			t.growup_level_id = gl.growup_level_id
			AND t.app_id = gl.app_id
		)
		LEFT JOIN (
			SELECT
				d.growup_level_id,
				d.app_id,
				count(DISTINCT d.user_id) AS cnt_level
			FROM
				growup_checkpoint_detail d
			WHERE
				d.app_id = 'csb'
			GROUP BY
				d.growup_level_id,
				d.app_id
		) TBP2 ON (
			t.growup_level_id = TBP2.growup_level_id
			AND t.app_id = TBP2.app_id
		)
		LEFT JOIN growup_path gp ON (
			t.growup_path_id = gp.growup_path_id
			AND t.app_id = gp.app_id
		)
		LEFT JOIN (
			SELECT
				d.growup_path_id,
				d.app_id,
				count(DISTINCT d.user_id) AS cnt_path
			FROM
				growup_checkpoint_detail d
			WHERE
				d.app_id = 'csb'
			GROUP BY
				d.growup_path_id,
				d.app_id
		) TBP3 ON (
			t.growup_path_id = TBP3.growup_path_id
			AND t.app_id = TBP3.app_id
		)
	) TBL