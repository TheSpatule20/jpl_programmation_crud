import 'package:jpl_programmation_crud/src/data_source_information.dart';

abstract class DataSource {
  List<dynamic> cells();
  List<DataSourceInformation> get informationDataSource;

}
