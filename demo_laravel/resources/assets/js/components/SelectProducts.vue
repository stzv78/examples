<template>
    <div class="step1">
        <form action="" class="form">
            <transition v-if="step === 1">
                <div id="step1" class="step">
                    <div class="a-title a-title_mb">
                        <div class="a-title__h3">Выбор продукции</div>
                    </div>
                    <div class="product-list js-product-list" v-for="(item, index) in productList">
                        <div class="products__row js-product">
                            <div class="products__td products__td-number">
                                <span class="products__number">{{index + 1}}.{{item.index}}</span>
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Марка</div>
                                <drop-down
                                        v-bind:list="products.brand"
                                        :placeholder="'Товар'"
                                        v-bind:default-selected=item.brand
                                        :disabled="false"
                                        @change="changeProduct(index, $event)"
                                ></drop-down>
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Граммаж</div>
                                <drop-down
                                        v-bind:list="(item.brand > -1) ? products.brand[item.brand].grammage : false"
                                        :placeholder="'Граммаж'"
                                        v-bind:default-selected=item.grammage
                                        @change="changeGrammage(index, $event)"
                                ></drop-down>
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Формат</div>
                                <drop-down
                                        v-bind:list="(item.brand > -1 && item.grammage > -1) ? products.brand[item.brand].grammage[item.grammage].format: false"
                                        :placeholder="'Формат'"
                                        v-bind:default-selected=item.format
                                        @change="changeFormat(index, $event)"
                                ></drop-down>
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Объём 1 декада</div>
                                <input type="text" class="form__input "
                                       :class="{ disabled : item.volume_1 === false }"
                                       v-model="item.volume_1"
                                       v-on:keyup="calcPrice(index)"
                                >
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Объём 2 декада</div>
                                <input type="text" class="form__input form__input"
                                       :class="{ disabled : item.volume_2 === false }"
                                       v-model="item.volume_2"
                                       v-on:keyup="calcPrice(index)"
                                >
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Объём 3 декада</div>
                                <input type="text" class="form__input form__input"
                                       :class="{ disabled : item.volume_3 === false }"
                                       v-model="item.volume_3"
                                       v-on:keyup="calcPrice(index)"
                                >
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Способ доставки</div>
                                <drop-down
                                        v-bind:list="(item.brand > -1 && item.grammage > -1 && item.format > -1) ? products.brand[item.brand].grammage[item.grammage].format[item.format].deliveries: false"
                                        :placeholder="'Способ доставки'"
                                        v-bind:default-selected=item.delivery
                                        @change="changeDelivery(index, $event); calcPrice(index);"
                                ></drop-down>
                            </div>
                            <div class="products__td products__td-flex1">
                                <div class="info-title products__info-title"
                                     v-bind:class="{ 'products__info-title_mob': index > 0 }">Сумма без НДС</div>
                                <div type="text" class="form__input form__input form__input_bold">
                                    {{ productList[index].price }}
                                </div>
                            </div>
                            <div class="products__td">
                                <i class="icon icon-trash "
                                   v-on:click.prevent="delProduct(index)"></i>
                            </div>
                        </div>
                        <div v-for="(e_item, e_index) in item.errors">
                            <span class="pf-alert">
                                 {{ e_item }}
                            </span>
                        </div>
                    </div>
                    <div class="products-add">
                        <a class="add-btn" href=""
                           v-on:click.prevent="addProduct()">Добавить товар</a>
                    </div>
                    <div class="anew-toolbar">
                        <a class="btn btn_inversed" v-on:click.prevent="cancelOrder()">Отменить</a>
                        <a class="btn" v-on:click.prevent="sendForm()">Отправить</a>
                    </div>
                </div>
            </transition>

            <div id="step2" class="step" v-if="step === 2">
                <div class="a-information">
                    <div class="a-goods">
                        <div class="a-title">
                            <div class="a-title__h3">Товары в заявке</div>
                        </div>
                        <table class="table a-table">
                            <thead>
                            <tr>
                                <th class="table__th">№</th>
                                <th class="table__th a-table__th-name">Марка</th>
                                <th class="table__th a-table__th-name">Граммаж</th>
                                <th class="table__th a-table__th-name">Формат</th>
                                <th class="table__th a-table__th-number">Объем 1 декада</th>
                                <th class="table__th a-table__th-number">Объем 2 декада</th>
                                <th class="table__th a-table__th-number">Объем 3 декада</th>
                                <th class="table__th a-table__th-name">Вид доставки</th>
                                <th class="table__th a-table__th-price">Сумма без НДС</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(item, index) in productList">
                                <template>
                                    <td class="table__td">{{index+1}}</td>
                                    <td class="table__td">{{item.range.brand}}</td>
                                    <td class="table__td">{{item.range.grammage}}</td>
                                    <td class="table__td">{{item.range.format}}</td>
                                    <td class="table__td">
                                        {{item.volume_1}}
                                        <template v-if="item.past_data">
                                            <span class="pf-alert">{{item.past_data.volume_1}}</span>
                                        </template>
                                    </td>
                                    <td class="table__td">
                                        {{item.volume_2}}
                                        <template v-if="item.past_data">
                                            <span class="pf-alert">{{item.past_data.volume_2}}</span>
                                        </template>
                                    </td>
                                    <td class="table__td">
                                        {{item.volume_3}}
                                        <template v-if="item.past_data">
                                            <span class="pf-alert">{{item.past_data.volume_3}}</span>
                                        </template>
                                    </td>
                                    <td class="table__td">{{item.delivery_main.name}}</td>
                                    <td class="table__td">
                                        {{item.price}}
                                        <template v-if="item.past_data">
                                            <span class="pf-alert">{{item.past_data.price}}</span>
                                        </template>
                                    </td>
                                </template>
                            </tr>
                            <tr>
                                <td colspan="9" class="table__td table__td_summary table__td_left">
                                    <div class="table__summary">
                                        <span class="table__summary-title">Итого:</span> {{totalVolume}} т
                                    </div>
                                    <div class="table__summary">
                                        <span class="table__summary-title">Итоговая сумма:</span> {{totalPrice}} <span
                                            class="rouble">q</span>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <div class="a-comment comment">
                            <span class="comment__title">Комментарий:</span>
                            <div class="comment__text">
                                <textarea id="comment" class="form-control comment__textarea" name="comment" value="" rows="6"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <a href="#cancelPopup" class="btn btn_small btn_full js-modal">Отменить</a>
                <a class="btn btn_inversed" v-on:click.prevent="prevStep()">Редактировать</a>
                <a class="btn" v-on:click.prevent="sendConfirm()">Подтвердить</a>
            </div>
        </form>
    </div>
</template>
<script>
    export default {
        props: [
            'step',
            'application',
            'applicator',
            'cancel_href',
            'send_href',
            'send_confirm_href',
            'application_products'
        ],

        data: function () {
            return {
                title: 'Новая заявка',
                products: [],
                productList: this.application_products
            }
        },

        mounted() {
            this.getProducts();
        },

        computed: {
            totalPrice: function () {
                var total = 0;
                for (var i = 0; this.productList.length > i; i++) {
                    total = total + Number(this.productList[i].price);
                }
                return total;
            },
            totalVolume: function () {
                var volume = 0;
                for (var i = 0; this.productList.length > i; i++) {
                    volume = volume + this.itemVolume(i);
                }
                return volume;
            }
        },

        watch: {},
        methods: {
            prevStep: function (n) {
                n = n || 1;
                this.step = this.step - n;
            },

            cancelOrder: function() {
                var template = '\t<div id="appCancel" class="popup popup_wide cntr">\n' +
                    '\t\t<h3 class="popup__title-cnt">Вы действительно хотите отменить заявку?</h3>\n' +
                    '\t\t<div class="popup__toolbar">\n' +
                    '\t\t\t<a class="btn btn_inversed" onclick="parent.$.fancybox.close();">Нет</a>\n' +
                    '\t\t\t<a href="'+ this.cancel_href +'" class="btn">Да</a>\n' +
                    '\t\t</div>\n' +
                    '\t</div>\n';

                $.fancybox.open({
                    src : template,
                    type : 'inline',
                    animationEffect : 'fade',
                    baseClass : 'application-modal',
                    toolbar : false,
                    smallBtn : false,
                    touch : false,
                    closeClickOutside : false,
                    modal : true,
                    helpers : {
                        overlay : {
                            closeClick : false
                        }
                    }
                });
            },

            getProducts() {
                let route = '/user/' + this.applicator + '/application/' + this.application +  '/get/products/';
                axios.get(route).then((response) => {
                    this.products = response.data.products;
                    if (this.products.length > 0) {
                        this.showProducts = true
                    }
                })
                .catch(error => {
                    this.showProducts = false
                    console.log(error)
                });
            },

            changeProduct: function (indexProductList, indexProduct) {
                this.productList[indexProductList].brand = indexProduct;
                this.productList[indexProductList].grammage = -1;
                this.productList[indexProductList].format = -1;
                this.productList[indexProductList].min_lot = 0;
                this.productList[indexProductList].delivery = -1;
                this.productList[indexProductList].price = 0;
            },

            changeGrammage: function (indexProductList, indexProduct) {
                this.productList[indexProductList].grammage = indexProduct;
                this.productList[indexProductList].format = -1;
                this.productList[indexProductList].delivery = -1;
                this.productList[indexProductList].price = 0;
            },

            changeDelivery: function (indexProductList, indexProduct) {
                var item = this.productList[indexProductList];
                var product = this.products.brand[item.brand].grammage[item.grammage].format[item.format];
                this.productList[indexProductList].delivery_id = product.deliveries[indexProduct].delivery_id;
                this.productList[indexProductList].delivery = indexProduct;
            },

            changeFormat: function (indexProductList, indexProduct) {
                this.productList[indexProductList].format = indexProduct;
                var item = this.productList[indexProductList];
                var product = this.products.brand[item.brand].grammage[item.grammage].format[item.format];
                this.productList[indexProductList].productrange_id = product.productrange_id;
                this.productList[indexProductList].min_lot = product.min_lot;
            },

            itemVolume(indexProductList) {
                var itemVolume = 0;
                itemVolume = Number(this.productList[indexProductList].volume_1) + Number(this.productList[indexProductList].volume_2) + Number(this.productList[indexProductList].volume_3);
                return itemVolume;
            },

            calcPrice: function (indexProductList) {
                var price = 0;
                if (this.itemVolume(indexProductList) > 0) {
                    price = this.products.brand[this.productList[indexProductList].brand].grammage[this.productList[indexProductList].grammage].format[this.productList[indexProductList].format].deliveries[this.productList[indexProductList].delivery].price;
                    this.productList[indexProductList].price = this.itemVolume(indexProductList) * price;
                } else this.productList[indexProductList].price = price;
            },

            addProduct: function (e) {
                this.productList.push({
                    productrange_id: 0,
                    brand: -1,
                    grammage: -1,
                    format: -1,
                    min_lot: 0,
                    volume_1: 0,
                    volume_2: 0,
                    volume_3: 0,
                    delivery: -1,
                    price: 0,
                    delivery_id: 0,
                    errors: [],
                });
            },

            delProduct: function (index) {
                this.productList.splice(index, 1);
            },

            sendForm: function () {
                var _productList = [];
                for (var i = 0; this.productList.length > i; i++) {
                    _productList[i] = {
                        delivery: this.productList[i].delivery_id,
                        format: this.productList[i].format,
                        grammage: this.productList[i].grammage,
                        id: this.productList[i].productrange_id,
                        min_lot: this.productList[i].min_lot,
                        price: this.productList[i].price,
                        volume_1: this.productList[i].volume_1,
                        volume_2: this.productList[i].volume_2,
                        volume_3: this.productList[i].volume_3,
                        delivery_index: this.productList[i].delivery,
                    }
                    this.productList[i].errors = [];
                }

                var productList = this.productList;

                axios.post(this.send_href,
                    { data: _productList },
                ).then((response) => {
                    if(response.data.status == 'success'){
                        window.location = response.data.redirect;
                    } else {
                        $.each( response.data.errors, function( key, value ) {
                            productList[key].errors = value;
                        });
                    }
                }).catch(error => {
                    console.log(error);
                });
            },

            sendConfirm: function () {
                var _productList = [];
                var comment = $('#comment').val();

                axios.post(this.send_confirm_href,
                    {
                        data: _productList,
                        comment: comment,
                    },
                ).then((response) => {
                    if(response.data.status == 'success'){
                        window.location = response.data.redirect;
                    } else {
                        console.log(response);
                    }
                }).catch(error => {
                    console.log(error)
                });
            }
        }
    }
</script>



