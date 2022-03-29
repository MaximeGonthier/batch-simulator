month_wallsmallerthan5 = month[month$requested_time<300, ] 

month_delaysmallerthan5 = month[month$run_time<300, ] 

month_delaysmallerthan5_1 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors==1, ]
month_delaysmallerthan5_2 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^1 & month_delaysmallerthan5$requested_number_of_processors<2^3, ]
month_delaysmallerthan5_3 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^3 & month_delaysmallerthan5$requested_number_of_processors<2^5, ]
month_delaysmallerthan5_4 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^5 & month_delaysmallerthan5$requested_number_of_processors<2^7, ]
month_delaysmallerthan5_5 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^7 & month_delaysmallerthan5$requested_number_of_processors<2^9, ]
month_delaysmallerthan5_6 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^9 & month_delaysmallerthan5$requested_number_of_processors<2^11, ]
month_delaysmallerthan5_7 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^11 & month_delaysmallerthan5$requested_number_of_processors<2^13, ]
month_delaysmallerthan5_8 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^13 & month_delaysmallerthan5$requested_number_of_processors<2^15, ]
month_delaysmallerthan5_9 = month_delaysmallerthan5[month_delaysmallerthan5$requested_number_of_processors>=2^15 & month_delaysmallerthan5$requested_number_of_processors<2^16, ]


