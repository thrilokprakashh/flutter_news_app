import 'package:news_app/models/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];
  CategoryModel categoryModel = new CategoryModel();

  categoryModel.categoryName = "Business";
  categoryModel.image = "assets/pexels-shoper-pl-550490863-17485352.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Entertainment";
  categoryModel.image = "assets/pexels-wendywei-1190297.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();
  categoryModel.categoryName = "General";
  categoryModel.image = "assets/pexels-edmond-dantes-7103187.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Health";
  categoryModel.image = "assets/pexels-pixabay-40568.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Science";
  categoryModel.image = "assets/pexels-chokniti-khongchum-1197604-2280571.jpg";
  category.add(categoryModel);
  categoryModel = new CategoryModel();
  categoryModel.categoryName = "Sports";
  categoryModel.image = "assets/pexels-football-wife-577822-1618269.jpg";
  category.add(categoryModel);
  return category;
}
