<template>
    <div class="flex receivers">
        <div class="receivers__col receivers__col-left">
            <div v-if="showSelect">
                <div class="receiver-title">Выберите грузополучателя</div>
                <select class="form__select-large single selectize-input" v-model="selected" @change="getProduct">
                    <option class="selectize-dropdown-content" v-for="(option, index) in options" :value="option">
                        {{ option.name }}
                    </option>
                </select>
            </div>
            <div v-else class="receiver-title">{{ selected.name }}</div>
            <div class="nm-address">
                {{ selected.address }}
            </div>
            <div class="flex banking">
                <div class="banking__item">
                    <span class="banking__title">ИНН:</span>
                    {{ selected.INN }}
                </div>
                <div class="banking__item">
                    <span class="banking__title">КПП:</span>
                    {{ selected.KPP }}
                </div>
            </div>

            <div class="info-line-small">
                Диаметр рулона: <span class="info-line-small__color">{{ selected.roll_diameter }}</span>
            </div>
            <div class="info-line-small">
                Диаметр гильзы: <span class="info-line-small__color">{{ selected.core_diameter }}</span>
            </div>
        </div>
        <div v-if="!showProducts" class="receiver-title">Нет данных о номенклатуре</div>
        <div v-else class="receivers__col receivers__col-right">
            <div class="infoblocks" v-for="product in products">
                <div class="infoblock flex">
                    <div class="infoblock__col">
                        <div class="info-title infoblock__info-title">Данные о грузе</div>
                        <div class="info-line-small">
                            Марка: <span class="info-line-small__color">{{ product.brand }}</span>
                        </div>
                        <div class="info-line-small">
                            Граммаж: <span class="info-line-small__color">{{ product.grammage }}</span>
                        </div>
                        <div class="info-line-small">
                            Формат: <span class="info-line-small__color">{{ product.format }}</span>
                        </div>
                    </div>
                    <div class="infoblock__col">
                        <div class="info-title infoblock__info-title">Объём продукции</div>
                        <div class="info-line-small">
                            Минимальная партия: <span class="info-line-small__color">{{ product.min_lot }} т</span>
                        </div>
                    </div>
                    <div class="infoblock__col">
                        <div class="info-title infoblock__info-title">Цена</div>
                        <div class="info-line-small" v-for="(delivery) in product.deliveries">
                            {{ delivery.name }}:
                            <span class="info-line-small__color">
                                {{ delivery.price }}<span class="rouble">q</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


<script>
    export default {
        props: [
            'applicator',
            'productranges',
        ],

        data() {
            return {
                selected: '',
                options: [],
                products: [],
                showProducts: '',
                showSelect: 'false'
            }
        },

        mounted() {
            this.getConsigneers();
        },

        methods: {
            getConsigneers() {
                let route = '/user/' + this.applicator + '/consigneers';
                axios.get(route).then((response) => {
                    this.options = response.data.consigneers;
                    if (this.options.length > 1) {
                        this.showSelect = true;
                    } else this.showSelect = false;
                    this.selected = this.options[0];
                    this.getProduct()
                }).catch(error => {
                        console.log(error)
                });
            },
            getProduct() {
                let route = '/user/' + this.applicator + '/get/productranges/' + this.selected.id;
                axios.get(route).then((response) => {
                    this.products = response.data.products;
                    if (this.products.length > 0) {
                        this.showProducts = true
                    }
                }).catch(error => {
                        this.showProducts = false
                        console.log(error)
                });

            }
        }
    }
</script>
