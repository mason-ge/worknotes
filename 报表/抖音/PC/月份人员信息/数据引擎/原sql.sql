SELECT
	TBL.*
FROM
	(
		SELECT
			TBB.all_user_month,
			(
				SELECT
					count(t.lecturer_user_id)
				FROM
					lecture_lecturer t
				WHERE
					t.app_id = 'csb'
				AND t.regedit_date IS NOT NULL
				AND concat(
					YEAR (t.regedit_date),
					LPAD(MONTH(t.regedit_date), 2, 0)
				) <= TBB.all_user_month
			) AS cnt_all_user
		FROM
			(
				SELECT
					concat(
						YEAR (t.regedit_date),
						LPAD(MONTH(t.regedit_date), 2, 0)
					) AS all_user_month,
					count(t.lecturer_user_id) AS cnt_all_user
				FROM
					lecture_lecturer t
				WHERE
					t.app_id = 'csb'
				AND t.regedit_date IS NOT NULL
				GROUP BY
					concat(
						YEAR (t.regedit_date),
						LPAD(MONTH(t.regedit_date), 2, 0)
					)
				ORDER BY
					CAST(
						concat(
							YEAR (t.regedit_date),
							LPAD(MONTH(t.regedit_date), 2, 0)
						) AS DECIMAL
					)
			) TBB
	) TBL