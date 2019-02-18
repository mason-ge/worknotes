SELECT
	TBL.*
FROM
	(
		SELECT
			ei.examine_name AS examine_name,
			ss. CODE AS shop_code,
			ss. NAME AS shop_name,
			(
				CASE
				WHEN ei. STATUS = '0' THEN
					'未生效'
				WHEN ei. STATUS = '1' THEN
					'评分中'
				WHEN ei. STATUS = '2' THEN
					'已评分'
				WHEN ei. STATUS = '3' THEN
					'已存档'
				ELSE
					''
				END
			) AS examine_status,
			ei.sum_score AS sum_score,
			round(ei.finally_score, 2) AS finally_score,
			es.standard_category AS standard_category,
			es.standard_type AS standard_type,
			es.examine_content AS examine_content,
			es.standard_score AS standard_score,
			(
				CASE
				WHEN ess.is_fit = '0' THEN
					'是'
				ELSE
					'否'
				END
			) AS if_suit,
			ifnull(ess.grade_score, '') AS grade_score,
			ess.deduction_reason AS deduction_reason,
			su. NAME AS grade_user,
			ei.grade_date AS grade_date
		FROM
			examine_store_info ei
		INNER JOIN sys_org_shop ss ON (ei.shop_id = ss.sys_org_id)
		INNER JOIN examine_standard es ON (
			es.examine_code = ei.examine_code
		)
		LEFT JOIN examine_standard_score ess ON (
			ess.examine_id = ei.examine_id
			AND es.standard_id = ess.standard_id
		)
		LEFT JOIN sys_user su ON (
			ei.grade_user = su.sys_user_id
		)
		WHERE
			1 = 1
		AND ei.app_id = 'csb'
	) TBL