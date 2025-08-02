#!/bin/bash

echo "🚀 بدء عملية حذف الملفات غير المستخدمة..."

files_to_delete=(
  "lib/core/constants/mock_data.dart"
  "lib/core/providers/data_providers.dart"
  "lib/core/providers/json_data_providers.dart"
  "lib/core/services/data_service.dart"
  "lib/core/services/json_data_service.dart"
  "lib/core/services/progress_service.dart"
  "lib/core/data/models/track_model.dart"
  "lib/core/data/repositories/python_repository.dart"
  "lib/features/home/presentation/widgets/track_card.dart"
  "lib/features/home/presentation/widgets/stats_overview.dart"
  "lib/features/home/presentation/widgets/modern_track_card.dart"
  "lib/cards"
)

for file in "${files_to_delete[@]}"
do
  if [ -e "$file" ]; then
    echo "🧨 حذف: $file"
    rm -rf "$file"
  else
    echo "✅ الملف غير موجود بالفعل: $file"
  fi
done

echo "✅ تم الحذف بنجاح! الكود أصبح أنضف من ضمير المهندس 😅"
