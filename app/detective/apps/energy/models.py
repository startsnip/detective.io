# -*- coding: utf-8 -*-
# The ontology can be found in its entirety at http://www.semanticweb.org/nkb/ontologies/2013/6/impact-investment#
from neo4django.db import models
from neo4django.auth.models import User
from app.detective.apps.common.models import *

class EnergyProduct(models.NodeModel):
	_parent = u'Product'
	_scope = u'energy'
	_description = u'An energy Product represents the concrete emanation of an energy Project. It can be a mass-produced device or a power plant.'
	_status = models.IntegerProperty(null=True,help_text=u'',verbose_name=u'status')
	power_generation_per_unit_in_watt = models.IntegerProperty(null=True,help_text=u'The amount of energy, in watts, that can be generated by each unit of the product.',verbose_name=u'Power generation per unit (in watts)')
	households_served = models.IntegerProperty(null=True,help_text=u'The number of households that can use the product. E.g. an oven is for 1 household, a lamp is for 0.25 households, a power plant is for (power / average household consumption in the region) households. Leave blank if you\'re unsure.',verbose_name=u'Households served')
	source = models.URLProperty(null=True,help_text=u'The URL (starting with http://) to your source. If the source is a book, enter the URL to the book at Google Books or Amazon.',verbose_name=u'Source')
	name = models.StringProperty(null=True,help_text=u'')
	image = models.URLProperty(null=True,help_text=u'The URL (starting with http://) where the image is hosted.',verbose_name=u'Image URL')
	_author = models.Relationship(User,null=True,rel_type='energy_product_energy_product_has_admin_author+',help_text=u'People that edited this entity.',verbose_name=u'author')
	distribution = models.Relationship(Distribution,null=True,rel_type='energy_product_has_distribution+',help_text=u'A Distribution represents the batch sales or gift of a product. Companies often communicate in terms of "in year X, Y units of Product Z were sold/distributed in Country A".',verbose_name=u'Distribution')
	operator = models.Relationship(Organization,null=True,rel_type='energy_product_has_operator+',help_text=u'Products, especially large ones such as power plants, have an Operator, usually a company.',verbose_name=u'Operator')
	price = models.Relationship(Price,null=True,rel_type='energy_product_has_price+',help_text=u'The price (use only digits, i.e. 8.99) of the Product at the date considered.',verbose_name=u'Price')

	class Meta: 
		verbose_name = u'Energy product'
		verbose_name_plural = u'Energy products'

	def __unicode__(self):
		return self.name or u"Unkown"


class EnergyProject(models.NodeModel):
	_parent = u'Project'
	_scope = u'energy'
	_description = u'An energy Project represents an endeavor to reach a particular aim (e.g. improve access to electricity, produce electricity in a certain way, improve energy efficiency, etc.). A project is the child of an Organization and takes its concrete form most often through Products.'
	_status = models.IntegerProperty(null=True,help_text=u'',verbose_name=u'status')
	source = models.URLProperty(null=True,help_text=u'The URL (starting with http://) to your source. If the source is a book, enter the URL to the book at Google Books or Amazon.',verbose_name=u'Source')
	twitter_handle = models.StringProperty(null=True,help_text=u'The Twitter name of the entity (without the @)',verbose_name=u'Twitter handle')
	ended = models.DateTimeProperty(null=True,help_text=u'The date when the project or organization ended.',verbose_name=u'End date')
	started = models.DateTimeProperty(null=True,help_text=u'Date when the project was started. Can be anterior to the date when the parent organization was created.',verbose_name=u'Start date')
	comment = models.StringProperty(null=True,help_text=u'Enter a short comment to the entity you are reporting on (max. 500 characters).',verbose_name=u'Comment')
	image = models.URLProperty(null=True,help_text=u'The URL (starting with http://) where the image is hosted.',verbose_name=u'Image URL')
	name = models.StringProperty(null=True,help_text=u'')
	_author = models.Relationship(User,null=True,rel_type='energy_project_energy_project_has_admin_author+',help_text=u'People that edited this entity.')
	product = models.Relationship(EnergyProduct,null=True,rel_type='energy_project_has_product+',help_text=u'A Product represents the concrete emanation of an energy Project. It can be a mass-produced device or a power plant.')
	partner = models.Relationship(Organization,null=True,rel_type='energy_project_has_partner+',help_text=u'An entity can have Partners, i.e. Organizations that help without making a financial contribution (if financial or substancial help is involved, use Fundraising Round instead).')
	commentary = models.Relationship(Commentary,null=True,rel_type='energy_project_has_commentary+',help_text=u'A Commentary is an article, a blog post or a report that assesses the quality of the Project.')
	activity_in_country = models.Relationship(Country,null=True,rel_type='energy_project_has_activity_in_country+',help_text=u'The list of countries or territories the entity is active in. ')
	owner = models.Relationship(Organization,null=True,rel_type='energy_project_has_owner+',help_text=u'The formal Owner of the entity.')

	class Meta:
		verbose_name = u'Energy project'
		verbose_name_plural = u'Energy projects'

	def __unicode__(self):
		return self.name or u"Unkown"
