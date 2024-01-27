// Flutter Exports
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'dart:async';
export 'dart:convert';

// External Packages Exports
export 'package:just_audio/just_audio.dart';
export 'package:dio/dio.dart';

// Config Exports
export 'package:simplemusicplayer/config/route/routes.dart';
export 'package:simplemusicplayer/config/constants/colors/app_colors.dart';
export 'package:simplemusicplayer/config/constants/colors/primitive_colors.dart';

// Core Exports
export 'package:simplemusicplayer/core/bloc/bloc_observer.dart';
export 'package:simplemusicplayer/core/network/hive/hive_service.dart';
export 'package:simplemusicplayer/core/common/hive/hive_service/setting_hive_service.dart';
export 'package:simplemusicplayer/injection/app_injection_container.dart';
export 'package:simplemusicplayer/core/failure/error_handler.dart';
export 'package:simplemusicplayer/core/app.dart';

// Extensions Exports
export 'package:simplemusicplayer/core/utils/extensions/app_text_theme_extension.dart';

// Cubit Exports
export 'package:simplemusicplayer/features/now_playing/presentation/cubit/now_playing_cubit.dart';
export 'package:simplemusicplayer/features/home/presentation/cubit/query_cubit.dart';
