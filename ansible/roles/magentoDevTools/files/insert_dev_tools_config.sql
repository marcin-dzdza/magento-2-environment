DELETE FROM `core_config_data` WHERE `path` IN (
'msp_devtools/general/enabled',
'msp_devtools/phpstorm/enabled'
);
INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES (
'default',
0,
'msp_devtools/general/enabled',
1
);
INSERT INTO `core_config_data` (`scope`, `scope_id`, `path`, `value`) VALUES (
'default',
0,
'msp_devtools/phpstorm/enabled',
1
);